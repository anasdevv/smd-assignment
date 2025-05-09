import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final SupabaseClient _supabase;
  final String _bucketName;

  StorageService({
    required SupabaseClient supabase,
    String bucketName = 'group-files',
  })  : _supabase = supabase,
        _bucketName = bucketName;

  Future<String> uploadFile(PlatformFile file) async {
    try {
      final fileExt = path.extension(file.name);
      final fileName = '${const Uuid().v4()}$fileExt';
      final filePath = 'group-files/$fileName';

      // Upload file to Supabase Storage
      await _supabase.storage.from(_bucketName).uploadBinary(
            filePath,
            file.bytes!,
            fileOptions: FileOptions(
              contentType: lookupMimeType(file.name),
            ),
          );

      // Get public URL
      final fileUrl =
          _supabase.storage.from(_bucketName).getPublicUrl(filePath);
      return fileUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      final filePath = fileUrl.split('/').last;
      await _supabase.storage.from(_bucketName).remove([filePath]);
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  Future<List<FileObject>> listFiles(String folder) async {
    try {
      final files =
          await _supabase.storage.from(_bucketName).list(path: folder);
      return files;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }

  Future<String> getFileUrl(String filePath) async {
    try {
      return _supabase.storage.from(_bucketName).getPublicUrl(filePath);
    } catch (e) {
      throw Exception('Failed to get file URL: $e');
    }
  }
}
