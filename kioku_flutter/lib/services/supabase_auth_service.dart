import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class SupabaseAuthService {
  static final SupabaseAuthService _instance = SupabaseAuthService._internal();
  factory SupabaseAuthService() => _instance;
  SupabaseAuthService._internal();

  final SupabaseClient _client = SupabaseService.instance.client;

  // Get current user
  User? get currentUser => _client.auth.currentUser;

  // Get current user ID
  String? get currentUserId => _client.auth.currentUser?.id;

  // Check if user is authenticated
  bool get isAuthenticated => _client.auth.currentUser != null;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /**
   * Signs up a new user with email and password
   * @param email - User's email
   * @param password - User's password
   * @param fullName - User's full name
   * @returns AuthResponse with user data
   */
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
        },
      );
      return response;
    } catch (error) {
      throw Exception('Falha ao criar conta: $error');
    }
  }

  /**
   * Signs in a user with email and password
   * @param email - User's email
   * @param password - User's password
   * @returns AuthResponse with user data
   */
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Falha ao fazer login: $error');
    }
  }

  /**
   * Signs out the current user
   */
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Falha ao fazer logout: $error');
    }
  }

  /**
   * Sends a password reset email
   * @param email - User's email
   */
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Falha ao enviar email de recuperação: $error');
    }
  }

  /**
   * Updates user password
   * @param newPassword - New password
   */
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return response;
    } catch (error) {
      throw Exception('Falha ao atualizar senha: $error');
    }
  }

  /**
   * Gets user profile data
   * @returns Map with user profile data
   */
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      if (currentUserId == null) return null;

      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', currentUserId!)
          .single();

      return response;
    } catch (error) {
      throw Exception('Falha ao buscar perfil: $error');
    }
  }

  /**
   * Updates user profile data
   * @param data - Map with profile data to update
   * @returns Updated profile data
   */
  Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> data) async {
    try {
      if (currentUserId == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('user_profiles')
          .update(data)
          .eq('id', currentUserId!)
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Falha ao atualizar perfil: $error');
    }
  }

  /**
   * Deletes the current user account
   * This will delete the user from auth.users, which will cascade delete
   * all related data (user_profiles, decks, flashcards, study_sessions, etc.)
   */
  Future<void> deleteUserAccount() async {
    try {
      if (currentUserId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Call RPC function to delete user account
      await _client.rpc('delete_user_account', params: {
        'user_uuid': currentUserId!,
      });

      // Sign out after deletion
      await signOut();
    } catch (error) {
      throw Exception('Falha ao deletar conta: $error');
    }
  }
}
