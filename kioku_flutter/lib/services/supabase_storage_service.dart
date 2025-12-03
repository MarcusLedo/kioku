import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import './supabase_service.dart';
import './supabase_auth_service.dart';

class SupabaseStorageService {
  static final SupabaseStorageService _instance = SupabaseStorageService._internal();
  factory SupabaseStorageService() => _instance;
  SupabaseStorageService._internal();

  final SupabaseClient _client = SupabaseService.instance.client;
  final SupabaseAuthService _authService = SupabaseAuthService();

  // Bucket name for avatars
  static const String _avatarBucket = 'avatars';

  /**
   * Uploads an avatar image to Supabase Storage
   * @param file - The image file to upload
   * @returns Public URL of the uploaded image
   */
  Future<String> uploadAvatar(File file) async {
    try {
      final userId = _authService.currentUserId;
      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Generate unique filename
      final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '$userId/$fileName';

      // Upload to Supabase Storage (pass File directly)
      await _client.storage.from(_avatarBucket).upload(
        filePath,
        file,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );

      // Get public URL
      final publicUrl = _client.storage.from(_avatarBucket).getPublicUrl(filePath);

      return publicUrl;
    } catch (error) {
      throw Exception('Falha ao fazer upload da imagem: $error');
    }
  }

  /**
   * Deletes an avatar image from Supabase Storage
   * @param filePath - The path of the file to delete
   */
  Future<void> deleteAvatar(String filePath) async {
    try {
      await _client.storage.from(_avatarBucket).remove([filePath]);
    } catch (error) {
      // Ignore errors when deleting (file might not exist)
      print('Erro ao deletar avatar: $error');
    }
  }
}

