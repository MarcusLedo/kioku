import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_auth_service.dart';
import './supabase_service.dart';

class SupabaseStudyService {
  static final SupabaseStudyService _instance =
      SupabaseStudyService._internal();
  factory SupabaseStudyService() => _instance;
  SupabaseStudyService._internal();

  final SupabaseClient _client = SupabaseService.instance.client;
  final SupabaseAuthService _authService = SupabaseAuthService();

  /**
   * Creates a new study session
   * @param deckId - Deck ID
   * @param cardsStudied - Number of cards studied
   * @param durationMinutes - Duration in minutes
   * @param correctAnswers - Number of correct answers
   * @param incorrectAnswers - Number of incorrect answers
   * @returns Created study session data
   */
  Future<Map<String, dynamic>> createStudySession({
    required String deckId,
    required int cardsStudied,
    required int durationMinutes,
    int correctAnswers = 0,
    int incorrectAnswers = 0,
  }) async {
    try {
      if (_authService.currentUserId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('study_sessions')
          .insert({
            'user_id': _authService.currentUserId!,
            'deck_id': deckId,
            'cards_studied': cardsStudied,
            'duration_minutes': durationMinutes,
            'correct_answers': correctAnswers,
            'incorrect_answers': incorrectAnswers,
          })
          .select()
          .single();

      // Update user streak
      await updateUserStreak();

      return response;
    } catch (error) {
      throw Exception('Falha ao criar sessão de estudo: $error');
    }
  }

  /**
   * Gets user study sessions
   * @param limit - Maximum number of sessions to return
   * @returns List of study session data
   */
  Future<List<Map<String, dynamic>>> getUserStudySessions(
      {int limit = 30}) async {
    try {
      if (_authService.currentUserId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('study_sessions')
          .select()
          .eq('user_id', _authService.currentUserId!)
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Falha ao buscar sessões de estudo: $error');
    }
  }

  /**
   * Gets study statistics for a specific deck
   * @param deckId - Deck ID
   * @returns Statistics data
   */
  Future<Map<String, dynamic>> getDeckStudyStats(String deckId) async {
    try {
      final sessionsData = await _client
          .from('study_sessions')
          .select('id')
          .eq('deck_id', deckId)
          .count();

      final totalCardsData = await _client
          .from('study_sessions')
          .select('cards_studied')
          .eq('deck_id', deckId);

      final totalTimeData = await _client
          .from('study_sessions')
          .select('duration_minutes')
          .eq('deck_id', deckId);

      int totalCards = 0;
      int totalTime = 0;

      for (var session in totalCardsData) {
        totalCards += (session['cards_studied'] as int?) ?? 0;
      }

      for (var session in totalTimeData) {
        totalTime += (session['duration_minutes'] as int?) ?? 0;
      }

      return {
        'total_sessions': sessionsData.count ?? 0,
        'total_cards_studied': totalCards,
        'total_time_minutes': totalTime,
      };
    } catch (error) {
      throw Exception('Falha ao buscar estatísticas de estudo: $error');
    }
  }

  /**
   * Deletes all study sessions for a specific deck
   * @param deckId - Deck ID
   */
  Future<void> deleteDeckStudySessions(String deckId) async {
    try {
      if (_authService.currentUserId == null) {
        throw Exception('Usuário não autenticado');
      }

      await _client
          .from('study_sessions')
          .delete()
          .eq('user_id', _authService.currentUserId!)
          .eq('deck_id', deckId);
    } catch (error) {
      throw Exception('Falha ao deletar sessões de estudo: $error');
    }
  }

  /**
   * Updates user streak by calling PostgreSQL function
   */
  Future<void> updateUserStreak() async {
    try {
      if (_authService.currentUserId == null) return;

      await _client.rpc('update_user_streak',
          params: {'user_uuid': _authService.currentUserId!});
    } catch (error) {
      throw Exception('Falha ao atualizar streak: $error');
    }
  }

  /**
   * Gets user study statistics
   * @returns User statistics including streak and study time
   */
  Future<Map<String, dynamic>> getUserStudyStats() async {
    try {
      if (_authService.currentUserId == null) {
        throw Exception('Usuário não autenticado');
      }

      final profile = await _client
          .from('user_profiles')
          .select()
          .eq('id', _authService.currentUserId!)
          .single();

      final sessionsData = await _client
          .from('study_sessions')
          .select('id')
          .eq('user_id', _authService.currentUserId!)
          .count();

      return {
        'current_streak': profile['current_streak'] ?? 0,
        'longest_streak': profile['longest_streak'] ?? 0,
        'total_study_time': profile['total_study_time'] ?? 0,
        'total_sessions': sessionsData.count ?? 0,
      };
    } catch (error) {
      throw Exception('Falha ao buscar estatísticas do usuário: $error');
    }
  }

  /**
   * Gets study calendar data for the last 30 days
   * @returns List of dates with study activity
   */
  Future<List<Map<String, dynamic>>> getStudyCalendar() async {
    try {
      if (_authService.currentUserId == null) {
        throw Exception('Usuário não autenticado');
      }

      final thirtyDaysAgo =
          DateTime.now().subtract(Duration(days: 30)).toIso8601String();

      final response = await _client
          .from('study_sessions')
          .select('created_at, cards_studied')
          .eq('user_id', _authService.currentUserId!)
          .gte('created_at', thirtyDaysAgo)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Falha ao buscar calendário de estudos: $error');
    }
  }

  /**
   * Gets study dates for the last 35 days (5 weeks)
   * @returns Set of dates (as strings) when user studied
   */
  Future<Set<String>> getStudyDates() async {
    try {
      if (_authService.currentUserId == null) {
        throw Exception('Usuário não autenticado');
      }

      final thirtyFiveDaysAgo = DateTime.now().subtract(Duration(days: 35));
      final startDate = thirtyFiveDaysAgo.toIso8601String();

      final response = await _client
          .from('study_sessions')
          .select('created_at')
          .eq('user_id', _authService.currentUserId!)
          .gte('created_at', startDate);

      final Set<String> studyDates = {};

      for (var record in response) {
        final createdAt = record['created_at'] as String?;
        if (createdAt != null) {
          // Extract date part (YYYY-MM-DD) from timestamp
          final dateStr = createdAt.split('T')[0];
          studyDates.add(dateStr);
        }
      }

      return studyDates;
    } catch (error) {
      throw Exception('Falha ao buscar datas de estudo: $error');
    }
  }
}
