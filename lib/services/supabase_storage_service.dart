import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

class SupabaseStorageService {
  static final _supabase = Supabase.instance.client;

  /// Uploads a file to a specified bucket and returns the public URL.
  static Future<String> uploadFile({
    required String bucket,
    required String filePath,
    required String fileName,
  }) async {
    try {
      final file = File(filePath);
      final fileExtension = p.extension(filePath);
      final fullFileName = '$fileName$fileExtension';

      // Upload the file
      await _supabase.storage.from(bucket).upload(
            fullFileName,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      // Get the public URL
      final String publicUrl = _supabase.storage.from(bucket).getPublicUrl(fullFileName);
      return publicUrl;
    } catch (e) {
      print('Error uploading to Supabase Storage: $e');
      rethrow;
    }
  }

  /// Specialized method for profile photos
  static Future<String> uploadProfilePhoto(String filePath, String userId) async {
    return uploadFile(
      bucket: 'profiles',
      filePath: filePath,
      fileName: 'profile_$userId',
    );
  }

  /// Specialized method for resumes
  static Future<String> uploadResume(String filePath, String userId) async {
    return uploadFile(
      bucket: 'resumes',
      filePath: filePath,
      fileName: 'resume_$userId',
    );
  }
}
