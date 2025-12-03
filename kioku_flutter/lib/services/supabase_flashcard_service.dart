import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';
import './supabase_deck_service.dart';

class SupabaseFlashcardService {
  static final SupabaseFlashcardService _instance =
      SupabaseFlashcardService._internal();
  factory SupabaseFlashcardService() => _instance;
  SupabaseFlashcardService._internal();

  final SupabaseClient _client = SupabaseService.instance.client;
  final SupabaseDeckService _deckService = SupabaseDeckService();

  /**
   * Gets all flashcards for a deck
   * @param deckId - Deck ID
   * @returns List of flashcard data
   */
  Future<List<Map<String, dynamic>>> getDeckFlashcards(String deckId) async {
    try {
      final response = await _client
          .from('flashcards')
          .select()
          .eq('deck_id', deckId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Falha ao buscar flashcards: $error');
    }
  }

  /**
   * Gets a single flashcard by ID
   * @param flashcardId - Flashcard ID
   * @returns Flashcard data
   */
  Future<Map<String, dynamic>> getFlashcardById(String flashcardId) async {
    try {
      final response = await _client
          .from('flashcards')
          .select()
          .eq('id', flashcardId)
          .single();

      return response;
    } catch (error) {
      throw Exception('Falha ao buscar flashcard: $error');
    }
  }

  /**
   * Creates a new flashcard
   * @param deckId - Deck ID
   * @param frontText - Front text
   * @param backText - Back text
   * @param difficulty - Difficulty level (easy, medium, hard)
   * @returns Created flashcard data
   */
  Future<Map<String, dynamic>> createFlashcard({
    required String deckId,
    required String frontText,
    required String backText,
    String difficulty = 'medium',
  }) async {
    try {
      final response = await _client
          .from('flashcards')
          .insert({
            'deck_id': deckId,
            'front_text': frontText,
            'back_text': backText,
            'difficulty': difficulty,
            'times_reviewed': 0,
            'times_correct': 0,
          })
          .select()
          .single();

      // Atualiza as estatísticas do deck
      await _deckService.updateDeckStats(deckId);

      return response;
    } catch (error) {
      throw Exception('Falha ao criar flashcard: $error');
    }
  }

  /**
   * Updates a flashcard
   * @param flashcardId - Flashcard ID
   * @param data - Data to update
   * @returns Updated flashcard data
   */
  Future<Map<String, dynamic>> updateFlashcard(
      String flashcardId, Map<String, dynamic> data) async {
    try {
      final response = await _client
          .from('flashcards')
          .update(data)
          .eq('id', flashcardId)
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Falha ao atualizar flashcard: $error');
    }
  }

  /**
   * Deletes a flashcard
   * @param flashcardId - Flashcard ID
   */
  Future<void> deleteFlashcard(String flashcardId) async {
    try {
      // Busca o deck_id antes de deletar
      final flashcard = await getFlashcardById(flashcardId);
      final deckId = flashcard['deck_id'] as String;

      await _client.from('flashcards').delete().eq('id', flashcardId);

      // Atualiza as estatísticas do deck
      await _deckService.updateDeckStats(deckId);
    } catch (error) {
      throw Exception('Falha ao deletar flashcard: $error');
    }
  }

  /**
   * Records a flashcard review result
   * @param flashcardId - Flashcard ID
   * @param wasCorrect - Whether the answer was correct
   */
  Future<void> recordReview(String flashcardId, bool wasCorrect) async {
    try {
      final flashcard = await getFlashcardById(flashcardId);

      final updatedData = {
        'times_reviewed': flashcard['times_reviewed'] + 1,
        'times_correct': flashcard['times_correct'] + (wasCorrect ? 1 : 0),
        'next_review_date': DateTime.now()
            .add(Duration(days: wasCorrect ? 3 : 1))
            .toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await updateFlashcard(flashcardId, updatedData);
    } catch (error) {
      throw Exception('Falha ao registrar revisão: $error');
    }
  }

  /**
   * Resets all flashcard statistics for a deck
   * @param deckId - Deck ID
   */
  Future<void> resetDeckFlashcardStats(String deckId) async {
    try {
      // Busca todos os flashcards do deck
      final flashcards = await getDeckFlashcards(deckId);

      // Reseta as estatísticas de cada flashcard
      for (var flashcard in flashcards) {
        final flashcardId = flashcard['id'] as String;
        await updateFlashcard(
          flashcardId,
          {
            'times_reviewed': 0,
            'times_correct': 0,
            'next_review_date': DateTime.now().toIso8601String(),
            'difficulty': 'medium',
            'updated_at': DateTime.now().toIso8601String(),
          },
        );
      }
    } catch (error) {
      throw Exception('Falha ao resetar estatísticas dos flashcards: $error');
    }
  }

  /**
   * Gets flashcards due for review
   * @param deckId - Deck ID
   * @returns List of flashcards due for review
   */
  Future<List<Map<String, dynamic>>> getDueFlashcards(String deckId) async {
    try {
      final response = await _client
          .from('flashcards')
          .select()
          .eq('deck_id', deckId)
          .lte('next_review_date', DateTime.now().toIso8601String())
          .order('next_review_date', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Falha ao buscar flashcards para revisão: $error');
    }
  }

  /**
   * Bulk creates flashcards from imported file
   * @param deckId - Deck ID
   * @param flashcards - List of flashcard data
   * @returns List of created flashcards
   */
  Future<List<Map<String, dynamic>>> bulkCreateFlashcards(
    String deckId,
    List<Map<String, String>> flashcards,
  ) async {
    try {
      final flashcardsToInsert = flashcards.map((card) {
        return {
          'deck_id': deckId,
          'front_text': card['front'] ?? '',
          'back_text': card['back'] ?? '',
          'difficulty': 'medium',
          'times_reviewed': 0,
          'times_correct': 0,
        };
      }).toList();

      final response =
          await _client.from('flashcards').insert(flashcardsToInsert).select();

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Falha ao importar flashcards: $error');
    }
  }
}
