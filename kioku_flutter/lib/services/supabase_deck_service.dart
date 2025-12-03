import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_auth_service.dart';
import './supabase_service.dart';

class SupabaseDeckService {
  static final SupabaseDeckService _instance = SupabaseDeckService._internal();
  factory SupabaseDeckService() => _instance;
  SupabaseDeckService._internal();

  final SupabaseClient _client = SupabaseService.instance.client;
  final SupabaseAuthService _authService = SupabaseAuthService();

  /**
   * Gets all decks for the current user with last study correct answers
   * @returns List of deck data with last_study_correct_answers
   */
  Future<List<Map<String, dynamic>>> getUserDecks() async {
    try {
      if (_authService.currentUserId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('decks')
          .select()
          .eq('user_id', _authService.currentUserId!)
          .order('created_at', ascending: false);

      final decks = List<Map<String, dynamic>>.from(response);

      // Para cada deck, busca os acertos do último estudo
      for (var deck in decks) {
        final deckId = deck['id'] as String;
        final lastStudyCorrect = await _getLastStudyCorrectAnswers(deckId);
        deck['last_study_correct_answers'] = lastStudyCorrect;
      }

      // Ordena os decks alfabeticamente por título (case-insensitive)
      decks.sort((a, b) {
        final titleA = (a['title'] as String? ?? '').toLowerCase();
        final titleB = (b['title'] as String? ?? '').toLowerCase();
        return titleA.compareTo(titleB);
      });

      return decks;
    } catch (error) {
      throw Exception('Falha ao buscar decks: $error');
    }
  }

  /**
   * Gets the number of correct answers from the last study session for a deck
   * @param deckId - Deck ID
   * @returns Number of correct answers (0 if no study session found)
   */
  Future<int> _getLastStudyCorrectAnswers(String deckId) async {
    try {
      if (_authService.currentUserId == null) {
        return 0;
      }

      final response = await _client
          .from('study_sessions')
          .select('correct_answers')
          .eq('user_id', _authService.currentUserId!)
          .eq('deck_id', deckId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        return 0;
      }

      return (response['correct_answers'] as int?) ?? 0;
    } catch (error) {
      // Em caso de erro, retorna 0
      return 0;
    }
  }

  /**
   * Gets a single deck by ID
   * @param deckId - Deck ID
   * @returns Deck data
   */
  Future<Map<String, dynamic>> getDeckById(String deckId) async {
    try {
      final response =
          await _client.from('decks').select().eq('id', deckId).single();

      return response;
    } catch (error) {
      throw Exception('Falha ao buscar deck: $error');
    }
  }

  /**
   * Checks if a deck with the given title already exists for the current user
   * @param title - Deck title to check
   * @returns true if deck exists, false otherwise
   */
  Future<bool> deckExistsWithTitle(String title) async {
    try {
      if (_authService.currentUserId == null) {
        return false;
      }

      final normalizedTitle = title.trim().toLowerCase();

      // Busca todos os decks do usuário e compara os títulos (case-insensitive)
      final response = await _client
          .from('decks')
          .select('id, title')
          .eq('user_id', _authService.currentUserId!);

      // Compara case-insensitive
      for (var deck in response) {
        final deckTitle = (deck['title'] as String? ?? '').trim().toLowerCase();
        if (deckTitle == normalizedTitle) {
          return true;
        }
      }

      return false;
    } catch (error) {
      // Em caso de erro, retorna false para não bloquear a criação
      print('Erro ao verificar deck existente: $error');
      return false;
    }
  }

  /**
   * Creates a new deck
   * @param title - Deck title
   * @param iconName - Icon name for the deck
   * @param isImported - Whether the deck was imported from a file
   * @returns Created deck data
   */
  Future<Map<String, dynamic>> createDeck({
    required String title,
    required String iconName,
    bool isImported = false,
  }) async {
    try {
      if (_authService.currentUserId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Verifica se já existe um deck com o mesmo título
      final exists = await deckExistsWithTitle(title);
      if (exists) {
        throw Exception('Já existe um deck com o nome "$title"');
      }

      final response = await _client
          .from('decks')
          .insert({
            'user_id': _authService.currentUserId!,
            'title': title,
            'icon_name': iconName,
            'total_cards': 0,
            'studied_cards': 0,
            'is_imported': isImported,
          })
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Falha ao criar deck: $error');
    }
  }

  /**
   * Updates a deck
   * @param deckId - Deck ID
   * @param data - Data to update
   * @returns Updated deck data
   */
  Future<Map<String, dynamic>> updateDeck(
      String deckId, Map<String, dynamic> data) async {
    try {
      final response = await _client
          .from('decks')
          .update(data)
          .eq('id', deckId)
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Falha ao atualizar deck: $error');
    }
  }

  /**
   * Deletes a deck
   * @param deckId - Deck ID
   */
  Future<void> deleteDeck(String deckId) async {
    try {
      await _client.from('decks').delete().eq('id', deckId);
    } catch (error) {
      throw Exception('Falha ao deletar deck: $error');
    }
  }

  /**
   * Updates deck statistics by calling the PostgreSQL function
   * @param deckId - Deck ID
   */
  Future<void> updateDeckStats(String deckId) async {
    try {
      await _client.rpc('update_deck_stats', params: {'deck_uuid': deckId});
    } catch (error) {
      throw Exception('Falha ao atualizar estatísticas do deck: $error');
    }
  }

  /**
   * Gets deck statistics
   * @param deckId - Deck ID
   * @returns Statistics data
   */
  Future<Map<String, dynamic>> getDeckStats(String deckId) async {
    try {
      final deck = await getDeckById(deckId);
      final flashcardsData = await _client
          .from('flashcards')
          .select('id')
          .eq('deck_id', deckId)
          .count();

      final studiedCardsData = await _client
          .from('flashcards')
          .select('id')
          .eq('deck_id', deckId)
          .gt('times_reviewed', 0)
          .count();

      return {
        'total_cards': flashcardsData.count,
        'studied_cards': studiedCardsData.count,
        'title': deck['title'],
        'icon_name': deck['icon_name'],
      };
    } catch (error) {
      throw Exception('Falha ao buscar estatísticas do deck: $error');
    }
  }
}
