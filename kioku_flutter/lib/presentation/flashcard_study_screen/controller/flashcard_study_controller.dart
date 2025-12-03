import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/flashcard_study_model.dart';
import '../../../services/supabase_flashcard_service.dart';
import '../../../services/supabase_study_service.dart';
import '../../../services/supabase_auth_service.dart';

class FlashcardStudyController extends GetxController {
  Rx<FlashcardStudyModel> flashcardStudyModelObj = FlashcardStudyModel().obs;

  final SupabaseFlashcardService _flashcardService = SupabaseFlashcardService();
  final SupabaseStudyService _studyService = SupabaseStudyService();
  final SupabaseAuthService _authService = SupabaseAuthService();

  RxString deckId = ''.obs;
  RxList<Map<String, dynamic>> flashcards = <Map<String, dynamic>>[].obs;
  RxInt currentIndex = 0.obs;
  RxInt selectedIndex = 1.obs;
  RxBool isAnswerRevealed = false.obs;
  RxBool isLoading = false.obs;
  Rx<int?> selectedAnswerIndex = Rx<int?>(null);
  Rx<String> selectedDifficulty = ''.obs; // Rastreia a dificuldade selecionada

  // Study session tracking
  RxInt cardsStudied = 0.obs;
  RxInt correctAnswers = 0.obs;
  RxInt incorrectAnswers = 0.obs;
  DateTime? sessionStartTime;

  @override
  void onInit() {
    super.onInit();
    sessionStartTime = DateTime.now();

    // Get flashcard data from arguments
    if (Get.arguments != null && Get.arguments is Map) {
      deckId.value = Get.arguments['deckId'] ?? '';

      if (Get.arguments['flashcards'] != null) {
        flashcards.value =
            List<Map<String, dynamic>>.from(Get.arguments['flashcards']);
        // Shuffle for random order
        flashcards.shuffle();
      }
    }
  }

  String get currentQuestion {
    if (currentIndex.value < flashcards.length) {
      return flashcards[currentIndex.value]['front_text'] ?? '';
    }
    return '';
  }

  String get currentAnswer {
    if (currentIndex.value < flashcards.length) {
      return flashcards[currentIndex.value]['back_text'] ?? '';
    }
    return '';
  }

  List<String> get currentAlternatives {
    if (currentIndex.value >= flashcards.length) return [];
    
    final backText = flashcards[currentIndex.value]['back_text'] ?? '';
    if (backText.isEmpty) return [];
    
    try {
      final decoded = jsonDecode(backText);
      if (decoded is Map && decoded.containsKey('alternatives')) {
        return List<String>.from(decoded['alternatives'] ?? []);
      }
    } catch (e) {
      // Se não for JSON, retorna o texto como única alternativa
      return [backText];
    }
    return [];
  }

  int get correctAnswerIndex {
    if (currentIndex.value >= flashcards.length) return -1;
    
    final backText = flashcards[currentIndex.value]['back_text'] ?? '';
    if (backText.isEmpty) return -1;
    
    try {
      final decoded = jsonDecode(backText);
      if (decoded is Map && decoded.containsKey('correct_index')) {
        return decoded['correct_index'] ?? -1;
      }
    } catch (e) {
      // Se não for JSON, a primeira (e única) alternativa é a correta
      return 0;
    }
    return -1;
  }

  String get currentFlashcardId {
    if (currentIndex.value < flashcards.length) {
      return flashcards[currentIndex.value]['id'] ?? '';
    }
    return '';
  }

  bool get hasMoreCards => currentIndex.value < flashcards.length - 1;
  int get totalCards => flashcards.length;
  int get currentCardNumber => currentIndex.value + 1;

  void onRevealAnswer() {
    if (!isAnswerRevealed.value) {
      isAnswerRevealed.value = true;
    } else {
      // Se já está revelado, reinicia para próxima pergunta
      _moveToNextCard();
    }
  }

  void onSelectAnswer(int index) {
    if (isAnswerRevealed.value) return; // Não permite selecionar após revelar
    
    selectedAnswerIndex.value = index;
    isAnswerRevealed.value = true;
    
    final isCorrect = index == correctAnswerIndex;
    _recordAnswer(isCorrect);
    
    // Move para próxima pergunta após 1 segundo
    Future.delayed(Duration(seconds: 1), () {
      _moveToNextCard();
    });
  }

  Future<void> onAnswerCorrect() async {
    await _recordAnswer(true);
    _moveToNextCard();
  }

  Future<void> onAnswerIncorrect() async {
    await _recordAnswer(false);
    _moveToNextCard();
  }

  Future<void> _recordAnswer(bool isCorrect) async {
    try {
      isLoading.value = true;

      // Update flashcard statistics (sempre registra, seja acerto ou erro)
      await _flashcardService.recordReview(
        currentFlashcardId,
        isCorrect,
      );

      if (isCorrect) {
        correctAnswers.value++;
      } else {
        incorrectAnswers.value++;
      }

      cardsStudied.value++;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível registrar a resposta: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDifficulty(String difficulty) async {
    try {
      // Salva a dificuldade selecionada
      selectedDifficulty.value = difficulty;
      
      // Atualiza no banco de dados
      await _flashcardService.updateFlashcard(
        currentFlashcardId,
        {'difficulty': difficulty},
      );
      
      // Aguarda um pequeno delay para o usuário ver o feedback visual
      await Future.delayed(Duration(milliseconds: 300));
      
      // Avança automaticamente para a próxima carta
      _moveToNextCard();
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível salvar a dificuldade: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _moveToNextCard() {
    // Só avança se a dificuldade foi selecionada
    if (selectedDifficulty.value.isEmpty) {
      return;
    }
    
    if (hasMoreCards) {
      currentIndex.value++;
      isAnswerRevealed.value = false;
      selectedAnswerIndex.value = null;
      selectedDifficulty.value = ''; // Reset para o próximo card
    } else {
      _finishStudySession();
    }
  }

  Future<void> _finishStudySession() async {
    try {
      final user = _authService.currentUser;
      if (user == null) return;

      final duration = DateTime.now().difference(sessionStartTime!).inMinutes;

      // Create study session record
      await _studyService.createStudySession(
        deckId: deckId.value,
        cardsStudied: cardsStudied.value,
        durationMinutes: duration > 0 ? duration : 1,
        correctAnswers: correctAnswers.value,
        incorrectAnswers: incorrectAnswers.value,
      );

      // Show completion dialog
      Get.dialog(
        AlertDialog(
          title: Text('Sessão Concluída!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Você estudou ${cardsStudied.value} flashcards'),
              SizedBox(height: 8),
              Text('Tempo: ${duration > 0 ? duration : 1} minutos'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                Get.back(); // Go back to deck details
              },
              child: Text('Voltar ao Deck'),
            ),
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                _restartSession();
              },
              child: Text('Estudar Novamente'),
            ),
          ],
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível salvar a sessão de estudo: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    }
  }

  void _restartSession() {
    currentIndex.value = 0;
    cardsStudied.value = 0;
    correctAnswers.value = 0;
    incorrectAnswers.value = 0;
    isAnswerRevealed.value = false;
    sessionStartTime = DateTime.now();
    flashcards.shuffle();
  }

  void onBottomNavTap(int index) {
    selectedIndex.value = index;
    if (index == 0) {
      Get.offAllNamed('/homepage-screen');
    } else if (index == 1) {
      Get.offAllNamed('/deck-listing-screen');
    } else if (index == 2) {
      Get.offAllNamed('/account-screen');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}