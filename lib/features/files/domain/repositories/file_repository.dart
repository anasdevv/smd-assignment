import 'package:smd_project/features/files/domain/entities/file_entity.dart';

abstract class FileRepository {
  Future<String> uploadFile(String groupId, String path, List<int> bytes);
  Future<void> deleteFile(String groupId, String path);
  Future<void> createFileRecord(String groupId, FileEntity file);
  Future<void> deleteFileRecord(String groupId, String fileId);
  Future<FileEntity?> getFile(String groupId, String fileId);
  Stream<List<FileEntity>> getGroupFiles(String groupId);
  Future<List<FileEntity>> searchFiles(String groupId, String query);
  Stream<List<FileEntity>> getFilesByType(String groupId, String type);
  Future<void> updateFileDescription(
      String groupId, String fileId, String description);
}
