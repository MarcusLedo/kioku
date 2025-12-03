import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cross_file/cross_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/deck_details_model.dart';
import '../../../services/supabase_deck_service.dart';
import '../../../services/supabase_flashcard_service.dart';
import '../../../services/supabase_auth_service.dart';
import '../../../services/supabase_study_service.dart';
import '../../../core/app_export.dart';

class DeckDetailsController extends GetxController {
  Rx<DeckDetailsModel> deckDetailsModelObj = DeckDetailsModel().obs;

  final SupabaseDeckService _deckService = SupabaseDeckService();
  final SupabaseFlashcardService _flashcardService = SupabaseFlashcardService();
  final SupabaseAuthService _authService = SupabaseAuthService();
  final SupabaseStudyService _studyService = SupabaseStudyService();

  RxString deckTitle = 'Deck'.obs;
  RxString deckId = ''.obs;
  RxString deckIconName = 'book'.obs;
  RxInt selectedIndex = 1.obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  RxList<Map<String, dynamic>> flashcards = <Map<String, dynamic>>[].obs;
  RxBool hasStudySessionsFlag = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Get deck data from arguments
    if (Get.arguments != null && Get.arguments is Map) {
      deckId.value = Get.arguments['deckId'] ?? '';
      deckTitle.value = Get.arguments['title'] ?? 'Deck';

      if (deckId.value.isNotEmpty) {
        _loadDeckData();
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    // Atualiza a flag quando a tela é exibida (útil após estudar)
    _checkStudySessions();
  }

  Future<void> _checkStudySessions() async {
    if (deckId.value.isNotEmpty) {
      hasStudySessionsFlag.value = await hasStudySessions();
    }
  }

  Future<void> _loadDeckData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Verify authentication
      final user = _authService.currentUser;
      if (user == null) {
        Get.offAllNamed('/authentication-screen');
        return;
      }

      // Load deck data to get icon
      final deckData = await _deckService.getDeckById(deckId.value);
      deckTitle.value = deckData['title'] ?? 'Deck';
      deckIconName.value = deckData['icon_name'] ?? 'book';

      // Load flashcards for this deck
      flashcards.value =
          await _flashcardService.getDeckFlashcards(deckId.value);

      // Verifica se há sessões de estudo
      hasStudySessionsFlag.value = await hasStudySessions();
    } catch (e) {
      errorMessage.value = 'Erro ao carregar dados: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await _loadDeckData();
    // Atualiza a flag de sessões de estudo
    hasStudySessionsFlag.value = await hasStudySessions();
  }

  Future<void> addFlashcard(String frontText, String backText) async {
    try {
      isLoading.value = true;

      await _flashcardService.createFlashcard(
        deckId: deckId.value,
        frontText: frontText,
        backText: backText,
      );

      await _loadDeckData();

      Get.snackbar(
        'Sucesso',
        'Flashcard adicionado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível adicionar o flashcard: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addFlashcardWithAlternatives(
    String question,
    List<String> alternatives,
    int correctIndex,
  ) async {
    try {
      isLoading.value = true;

      // Cria um JSON com as alternativas e a resposta correta
      final backTextJson = jsonEncode({
        'alternatives': alternatives,
        'correct_index': correctIndex,
      });

      await _flashcardService.createFlashcard(
        deckId: deckId.value,
        frontText: question,
        backText: backTextJson,
      );

      await _loadDeckData();

      Get.snackbar(
        'Sucesso',
        'Flashcard adicionado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível adicionar o flashcard: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteFlashcard(String flashcardId) async {
    try {
      isLoading.value = true;

      await _flashcardService.deleteFlashcard(flashcardId);
      await _loadDeckData();

      Get.snackbar(
        'Sucesso',
        'Flashcard excluído com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível excluir o flashcard: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFlashcard(
      String flashcardId, String frontText, String backText) async {
    try {
      isLoading.value = true;

      await _flashcardService.updateFlashcard(
        flashcardId,
        {
          'front_text': frontText,
          'back_text': backText,
        },
      );

      await _loadDeckData();

      Get.snackbar(
        'Sucesso',
        'Flashcard atualizado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível atualizar o flashcard: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onEditDeck() {
    final titleController = TextEditingController(text: deckTitle.value);
    int selectedIconIndex = 0;
    String selectedIconName = deckIconName.value;

    // Lista de ícones disponíveis
    final List<Map<String, dynamic>> availableIcons = [
      {'icon': Icons.psychology, 'name': 'psychology'},
      {'icon': Icons.school, 'name': 'school'},
      {'icon': Icons.book, 'name': 'book'},
      {'icon': Icons.lightbulb, 'name': 'lightbulb'},
      {'icon': Icons.science, 'name': 'science'},
      {'icon': Icons.calculate, 'name': 'calculate'},
      {'icon': Icons.language, 'name': 'language'},
      {'icon': Icons.history, 'name': 'history'},
      {'icon': Icons.public, 'name': 'public'},
      {'icon': Icons.code, 'name': 'code'},
      {'icon': Icons.medical_services, 'name': 'medical_services'},
      {'icon': Icons.business, 'name': 'business'},
    ];

    // Encontra o índice do ícone atual
    for (int i = 0; i < availableIcons.length; i++) {
      if (availableIcons[i]['name'] == selectedIconName) {
        selectedIconIndex = i;
        break;
      }
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.h),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(24.h),
              width: 400.h,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Editar Deck',
                      style: TextStyleHelper.instance.title20BoldOpenSans,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Título do Deck',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Digite o título do deck',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.h),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.h,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Escolha um ícone',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      height: 120.h,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8.h,
                          mainAxisSpacing: 8.h,
                        ),
                        itemCount: availableIcons.length,
                        itemBuilder: (context, index) {
                          final iconData = availableIcons[index]['icon'] as IconData;
                          final iconName = availableIcons[index]['name'] as String;
                          final isSelected = selectedIconIndex == index;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIconIndex = index;
                                selectedIconName = iconName;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? appTheme.cyan_A700
                                    : appTheme.gray_50,
                                borderRadius: BorderRadius.circular(12.h),
                                border: Border.all(
                                  color: isSelected
                                      ? appTheme.cyan_A700
                                      : appTheme.greyCustom,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Icon(
                                iconData,
                                color: isSelected
                                    ? appTheme.white_A700
                                    : appTheme.cyan_A700,
                                size: 28.h,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Botão de excluir
                    Container(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.back(); // Fecha o diálogo de edição primeiro
                          _showDeleteConfirmationDialog();
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 20.h,
                          color: appTheme.white_A700,
                        ),
                        label: Text(
                          'Excluir Deck',
                          style: TextStyleHelper.instance.body15RegularOpenSans
                              .copyWith(color: appTheme.white_A700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.h),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.h,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'Cancelar',
                            style: TextStyleHelper.instance.body15RegularOpenSans
                                .copyWith(color: appTheme.greyCustom),
                          ),
                        ),
                        SizedBox(width: 12.h),
                        ElevatedButton(
                          onPressed: () {
                            if (titleController.text.trim().isEmpty) {
                              Get.snackbar(
                                'Erro',
                                'Por favor, insira um título para o deck',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }
                            Get.back();
                            updateDeck(
                              titleController.text.trim(),
                              selectedIconName,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appTheme.cyan_A700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.h),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.h,
                              vertical: 12.h,
                            ),
                          ),
                          child: Text(
                            'Salvar',
                            style: TextStyleHelper.instance.body15RegularOpenSans
                                .copyWith(color: appTheme.white_A700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.h),
        ),
        title: Text(
          'Confirmar Exclusão',
          style: TextStyleHelper.instance.title20BoldOpenSans,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tem certeza que deseja excluir o deck "${deckTitle.value}"?',
              style: TextStyleHelper.instance.body15RegularOpenSans,
            ),
            SizedBox(height: 8.h),
            Text(
              'Esta ação não pode ser desfeita e todos os flashcards serão excluídos.',
              style: TextStyleHelper.instance.body14LightOpenSans.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                color: appTheme.greyCustom,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Fecha o diálogo de confirmação
              await _deleteDeck();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.h),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 24.h,
                vertical: 12.h,
              ),
            ),
            child: Text(
              'Excluir',
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                color: appTheme.white_A700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDeck() async {
    try {
      isLoading.value = true;

      await _deckService.deleteDeck(deckId.value);

      Get.snackbar(
        'Sucesso',
        'Deck excluído com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );

      // Volta para a tela de listagem de decks
      // Usa offAllNamed para limpar a pilha de navegação e garantir que a tela seja recriada
      Get.offAllNamed('/deck-listing-screen');
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível excluir o deck: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDeck(String title, String iconName) async {
    try {
      isLoading.value = true;

      await _deckService.updateDeck(
        deckId.value,
        {
          'title': title,
          'icon_name': iconName,
        },
      );

      // Atualiza o título local
      deckTitle.value = title;
      deckIconName.value = iconName;

      Get.snackbar(
        'Sucesso',
        'Deck atualizado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível atualizar o deck: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onAddCard() {
    final questionController = TextEditingController();
    final alternative1Controller = TextEditingController();
    final alternative2Controller = TextEditingController();
    final alternative3Controller = TextEditingController();
    final alternative4Controller = TextEditingController();
    int selectedCorrectAnswer = 0;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.h),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(24.h),
              width: 400.h,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adicionar Flashcard',
                      style: TextStyleHelper.instance.title20BoldOpenSans,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Pergunta',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: questionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Digite a pergunta...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.h),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.h,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Alternativas',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildAlternativeField(
                      context,
                      setState,
                      'Alternativa 1',
                      alternative1Controller,
                      0,
                      selectedCorrectAnswer,
                      (index) => setState(() => selectedCorrectAnswer = index),
                    ),
                    SizedBox(height: 12.h),
                    _buildAlternativeField(
                      context,
                      setState,
                      'Alternativa 2',
                      alternative2Controller,
                      1,
                      selectedCorrectAnswer,
                      (index) => setState(() => selectedCorrectAnswer = index),
                    ),
                    SizedBox(height: 12.h),
                    _buildAlternativeField(
                      context,
                      setState,
                      'Alternativa 3',
                      alternative3Controller,
                      2,
                      selectedCorrectAnswer,
                      (index) => setState(() => selectedCorrectAnswer = index),
                    ),
                    SizedBox(height: 12.h),
                    _buildAlternativeField(
                      context,
                      setState,
                      'Alternativa 4',
                      alternative4Controller,
                      3,
                      selectedCorrectAnswer,
                      (index) => setState(() => selectedCorrectAnswer = index),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'Cancelar',
                            style: TextStyleHelper.instance.body15RegularOpenSans
                                .copyWith(color: appTheme.greyCustom),
                          ),
                        ),
                        SizedBox(width: 12.h),
                        ElevatedButton(
                          onPressed: () {
                            if (questionController.text.trim().isEmpty) {
                              Get.snackbar(
                                'Erro',
                                'Por favor, preencha a pergunta',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }
                            
                            final alternatives = [
                              alternative1Controller.text.trim(),
                              alternative2Controller.text.trim(),
                              alternative3Controller.text.trim(),
                              alternative4Controller.text.trim(),
                            ].where((alt) => alt.isNotEmpty).toList();
                            
                            if (alternatives.length < 2) {
                              Get.snackbar(
                                'Erro',
                                'Preencha pelo menos 2 alternativas',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }
                            
                            // Ajusta o índice da resposta correta baseado nas alternativas preenchidas
                            int correctIndex = 0;
                            int filledCount = 0;
                            for (int i = 0; i < 4; i++) {
                              final controllers = [
                                alternative1Controller,
                                alternative2Controller,
                                alternative3Controller,
                                alternative4Controller,
                              ];
                              if (controllers[i].text.trim().isNotEmpty) {
                                if (i == selectedCorrectAnswer) {
                                  correctIndex = filledCount;
                                }
                                filledCount++;
                              }
                            }
                            
                            Get.back();
                            addFlashcardWithAlternatives(
                              questionController.text.trim(),
                              alternatives,
                              correctIndex,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appTheme.cyan_A700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.h),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.h,
                              vertical: 12.h,
                            ),
                          ),
                          child: Text(
                            'Adicionar',
                            style: TextStyleHelper.instance.body15RegularOpenSans
                                .copyWith(color: appTheme.white_A700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAlternativeField(
    BuildContext context,
    StateSetter setState,
    String label,
    TextEditingController controller,
    int index,
    int selectedCorrect,
    Function(int) onSelectCorrect,
  ) {
    final isSelected = selectedCorrect == index;
    return Row(
      children: [
        GestureDetector(
          onTap: () => onSelectCorrect(index),
          child: Container(
            width: 24.h,
            height: 24.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? appTheme.cyan_A700 : appTheme.greyCustom,
                width: 2,
              ),
              color: isSelected ? appTheme.cyan_A700 : Colors.transparent,
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    size: 16.h,
                    color: appTheme.white_A700,
                  )
                : null,
          ),
        ),
        SizedBox(width: 12.h),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
                borderSide: BorderSide(
                  color: isSelected ? appTheme.cyan_A700 : appTheme.greyCustom,
                  width: isSelected ? 2 : 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
                borderSide: BorderSide(
                  color: isSelected ? appTheme.cyan_A700 : appTheme.greyCustom,
                  width: isSelected ? 2 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.h),
                borderSide: BorderSide(
                  color: appTheme.cyan_A700,
                  width: 2,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 12.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onDeleteCard(String flashcardId) {
    Get.dialog(
      AlertDialog(
        title: Text('Excluir Flashcard'),
        content: Text('Deseja realmente excluir este flashcard?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteFlashcard(flashcardId);
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void onEditCard(String flashcardId, String currentFront, String currentBack) {
    // Tenta parsear o backText como JSON (alternativas) ou usa como texto simples
    List<String> alternatives = [];
    int correctIndex = 0;
    bool isAlternativesFormat = false;

    try {
      final decoded = jsonDecode(currentBack);
      if (decoded is Map && decoded.containsKey('alternatives')) {
        alternatives = List<String>.from(decoded['alternatives'] ?? []);
        correctIndex = decoded['correct_index'] ?? 0;
        isAlternativesFormat = true;
      }
    } catch (e) {
      // Não é JSON, é texto simples - converte para formato de alternativas
      alternatives = [currentBack];
      correctIndex = 0;
      isAlternativesFormat = true;
    }

    // Garante pelo menos 4 alternativas
    while (alternatives.length < 4) {
      alternatives.add('');
    }

    final questionController = TextEditingController(text: currentFront);
    final alternative1Controller = TextEditingController(text: alternatives[0]);
    final alternative2Controller = TextEditingController(text: alternatives.length > 1 ? alternatives[1] : '');
    final alternative3Controller = TextEditingController(text: alternatives.length > 2 ? alternatives[2] : '');
    final alternative4Controller = TextEditingController(text: alternatives.length > 3 ? alternatives[3] : '');
    int selectedCorrectAnswer = correctIndex;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.h),
        ),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(24.h),
              width: 400.h,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Editar Flashcard',
                      style: TextStyleHelper.instance.title20BoldOpenSans,
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Pergunta',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextField(
                      controller: questionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Digite a pergunta...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.h),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.h,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Alternativas',
                      style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildAlternativeField(
                      context,
                      setState,
                      'Alternativa 1',
                      alternative1Controller,
                      0,
                      selectedCorrectAnswer,
                      (index) => setState(() => selectedCorrectAnswer = index),
                    ),
                    SizedBox(height: 12.h),
                    _buildAlternativeField(
                      context,
                      setState,
                      'Alternativa 2',
                      alternative2Controller,
                      1,
                      selectedCorrectAnswer,
                      (index) => setState(() => selectedCorrectAnswer = index),
                    ),
                    SizedBox(height: 12.h),
                    _buildAlternativeField(
                      context,
                      setState,
                      'Alternativa 3',
                      alternative3Controller,
                      2,
                      selectedCorrectAnswer,
                      (index) => setState(() => selectedCorrectAnswer = index),
                    ),
                    SizedBox(height: 12.h),
                    _buildAlternativeField(
                      context,
                      setState,
                      'Alternativa 4',
                      alternative4Controller,
                      3,
                      selectedCorrectAnswer,
                      (index) => setState(() => selectedCorrectAnswer = index),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'Cancelar',
                            style: TextStyleHelper.instance.body15RegularOpenSans
                                .copyWith(color: appTheme.greyCustom),
                          ),
                        ),
                        SizedBox(width: 12.h),
                        ElevatedButton(
                          onPressed: () {
                            if (questionController.text.trim().isEmpty) {
                              Get.snackbar(
                                'Erro',
                                'Por favor, preencha a pergunta',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }
                            
                            final alternativesList = [
                              alternative1Controller.text.trim(),
                              alternative2Controller.text.trim(),
                              alternative3Controller.text.trim(),
                              alternative4Controller.text.trim(),
                            ].where((alt) => alt.isNotEmpty).toList();
                            
                            if (alternativesList.length < 2) {
                              Get.snackbar(
                                'Erro',
                                'Preencha pelo menos 2 alternativas',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }
                            
                            // Ajusta o índice da resposta correta baseado nas alternativas preenchidas
                            int correctIndex = 0;
                            int filledCount = 0;
                            for (int i = 0; i < 4; i++) {
                              final controllers = [
                                alternative1Controller,
                                alternative2Controller,
                                alternative3Controller,
                                alternative4Controller,
                              ];
                              if (controllers[i].text.trim().isNotEmpty) {
                                if (i == selectedCorrectAnswer) {
                                  correctIndex = filledCount;
                                }
                                filledCount++;
                              }
                            }
                            
                            Get.back();
                            updateFlashcardWithAlternatives(
                              flashcardId,
                              questionController.text.trim(),
                              alternativesList,
                              correctIndex,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appTheme.cyan_A700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.h),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.h,
                              vertical: 12.h,
                            ),
                          ),
                          child: Text(
                            'Salvar',
                            style: TextStyleHelper.instance.body15RegularOpenSans
                                .copyWith(color: appTheme.white_A700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> updateFlashcardWithAlternatives(
    String flashcardId,
    String question,
    List<String> alternatives,
    int correctIndex,
  ) async {
    try {
      isLoading.value = true;

      // Cria um JSON com as alternativas e a resposta correta
      final backTextJson = jsonEncode({
        'alternatives': alternatives,
        'correct_index': correctIndex,
      });

      await _flashcardService.updateFlashcard(
        flashcardId,
        {
          'front_text': question,
          'back_text': backTextJson,
        },
      );

      await _loadDeckData();

      Get.snackbar(
        'Sucesso',
        'Flashcard atualizado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível atualizar o flashcard: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> hasStudySessions() async {
    try {
      final stats = await _studyService.getDeckStudyStats(deckId.value);
      return (stats['total_sessions'] as int? ?? 0) > 0;
    } catch (e) {
      return false;
    }
  }

  Future<void> exportToPDF() async {
    try {
      isLoading.value = true;

      // Verifica se há sessões de estudo
      final hasSessions = await hasStudySessions();
      if (!hasSessions) {
        Get.snackbar(
          'Aviso',
          'Não há sessões de estudo para este deck ainda.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[900],
        );
        return;
      }

      // Busca dados do usuário
      final userProfile = await _authService.getUserProfile();
      final studentName = userProfile?['full_name'] ?? 'Estudante';

      // Busca estatísticas de estudo do deck
      final studyStats = await _studyService.getDeckStudyStats(deckId.value);
      final totalCardsStudied = studyStats['total_cards_studied'] as int? ?? 0;
      final totalTimeMinutes = studyStats['total_time_minutes'] as int? ?? 0;

      // Data de geração
      final reportDate = DateTime.now();
      final dateStr = '${reportDate.day.toString().padLeft(2, '0')}/${reportDate.month.toString().padLeft(2, '0')}/${reportDate.year}';

      // Calcula o tempo formatado
      final hours = totalTimeMinutes ~/ 60;
      final minutes = totalTimeMinutes % 60;
      final timeStr = hours > 0 
          ? '$hours hora${hours > 1 ? 's' : ''} e $minutes minuto${minutes != 1 ? 's' : ''}'
          : '$minutes minuto${minutes != 1 ? 's' : ''}';

      // Gera o PDF
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(40),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Título
                  pw.Text(
                    'Relatório de Estudo',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 30),
                  
                  // Nome do estudante
                  pw.Text(
                    'Nome do estudante:',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    studentName,
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  pw.SizedBox(height: 20),
                  
                  // Nome do deck
                  pw.Text(
                    'Nome do deck:',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    deckTitle.value,
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  pw.SizedBox(height: 20),
                  
                  // Data de geração
                  pw.Text(
                    'Data de geração do relatório:',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    dateStr,
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  pw.SizedBox(height: 30),
                  
                  // Métricas de estudo
                  pw.Text(
                    'Métricas de estudo:',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 15),
                  
                  // Número total de cards estudados
                  pw.Text(
                    '• Número total de cards estudados no período: $totalCardsStudied',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  pw.SizedBox(height: 10),
                  
                  // Tempo total de estudo
                  pw.Text(
                    '• Tempo total de estudo: $timeStr',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Salva o PDF temporariamente
      final directory = await getTemporaryDirectory();
      final fileName = '${deckTitle.value.replaceAll(RegExp(r'[^\w\s-]'), '_')}_relatorio_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      // Compartilha o PDF
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Relatório de estudo: ${deckTitle.value}',
        subject: 'Relatório ${deckTitle.value}',
      );

      Get.snackbar(
        'Sucesso',
        'PDF gerado e compartilhado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível gerar o PDF: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> shareDeck() async {
    try {
      if (flashcards.isEmpty) {
        Get.snackbar(
          'Aviso',
          'O deck não possui cards para compartilhar',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      isLoading.value = true;

      // Gera o CSV
      final csvContent = _generateDeckCSV();
      
      // Salva o arquivo temporariamente
      final directory = await getTemporaryDirectory();
      final fileName = '${deckTitle.value.replaceAll(RegExp(r'[^\w\s-]'), '_')}_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(csvContent);

      // Compartilha o arquivo
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Compartilhando deck: ${deckTitle.value}',
        subject: 'Deck ${deckTitle.value}',
      );

      Get.snackbar(
        'Sucesso',
        'Deck compartilhado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível compartilhar o deck: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _generateDeckCSV() {
    final buffer = StringBuffer();
    
    // Cabeçalho do CSV
    buffer.writeln('DECK_INFO');
    buffer.writeln('title,icon_name');
    buffer.writeln('${_escapeCSV(deckTitle.value)},${deckIconName.value}');
    buffer.writeln('');
    
    // Cabeçalho dos cards
    buffer.writeln('CARDS');
    buffer.writeln('front_text,alternatives,correct_index');
    
    // Dados dos cards
    for (var card in flashcards) {
      final frontText = card['front_text'] as String? ?? '';
      final backText = card['back_text'] as String? ?? '';
      
      try {
        // Tenta decodificar o JSON das alternativas
        final decoded = jsonDecode(backText);
        if (decoded is Map && decoded.containsKey('alternatives') && decoded.containsKey('correct_index')) {
          final alternatives = List<String>.from(decoded['alternatives'] ?? []);
          final correctIndex = decoded['correct_index'] as int? ?? 0;
          
          // Junta as alternativas com pipe (|)
          final alternativesStr = alternatives.map((alt) => _escapeCSV(alt)).join('|');
          
          buffer.writeln('${_escapeCSV(frontText)},$alternativesStr,$correctIndex');
        } else {
          // Formato antigo: apenas texto
          buffer.writeln('${_escapeCSV(frontText)},${_escapeCSV(backText)},0');
        }
      } catch (e) {
        // Se não for JSON, trata como texto simples
        buffer.writeln('${_escapeCSV(frontText)},${_escapeCSV(backText)},0');
      }
    }
    
    return buffer.toString();
  }

  String _escapeCSV(String value) {
    // Escapa aspas e vírgulas no CSV
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  void onBottomNavTap(int index) {
    selectedIndex.value = index;
    if (index == 0) {
      Get.offNamed('/homepage-screen');
    } else if (index == 1) {
      Get.offNamed('/deck-listing-screen');
    } else if (index == 2) {
      Get.offNamed('/account-screen');
    }
  }

  void startStudySession() {
    if (flashcards.isEmpty) {
      Get.snackbar(
        'Sem Flashcards',
        'Adicione flashcards ao deck para iniciar o estudo',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.toNamed(
      '/flashcard-study-screen',
      arguments: {
        'deckId': deckId.value,
        'flashcards': flashcards,
      },
    );
  }

  void showResetConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.h),
        ),
        title: Text(
          'Confirmar Reset',
          style: TextStyleHelper.instance.title20BoldOpenSans,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tem certeza que deseja resetar o deck "${deckTitle.value}"?',
              style: TextStyleHelper.instance.body15RegularOpenSans,
            ),
            SizedBox(height: 8.h),
            Text(
              'Esta ação irá:',
              style: TextStyleHelper.instance.body14LightOpenSans.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '• Deletar todo o histórico de estudos',
              style: TextStyleHelper.instance.body14LightOpenSans,
            ),
            Text(
              '• Resetar estatísticas de todos os cards',
              style: TextStyleHelper.instance.body14LightOpenSans,
            ),
            Text(
              '• Limpar contadores de acertos e erros',
              style: TextStyleHelper.instance.body14LightOpenSans,
            ),
            SizedBox(height: 8.h),
            Text(
              'Esta ação não pode ser desfeita.',
              style: TextStyleHelper.instance.body14LightOpenSans.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                color: appTheme.greyCustom,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Fecha o diálogo de confirmação
              await resetDeck();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.h),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 24.h,
                vertical: 12.h,
              ),
            ),
            child: Text(
              'Resetar',
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                color: appTheme.white_A700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> resetDeck() async {
    try {
      isLoading.value = true;

      // Deleta todas as sessões de estudo do deck
      await _studyService.deleteDeckStudySessions(deckId.value);

      // Reseta as estatísticas de todos os flashcards
      await _flashcardService.resetDeckFlashcardStats(deckId.value);

      // Atualiza as estatísticas do deck
      await _deckService.updateDeckStats(deckId.value);

      // Atualiza a flag de sessões de estudo
      hasStudySessionsFlag.value = false;

      // Recarrega os dados do deck
      await _loadDeckData();

      Get.snackbar(
        'Sucesso',
        'Deck resetado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível resetar o deck: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}