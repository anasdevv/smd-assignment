import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smd_project/features/files/data/models/file_model.dart';
import 'package:smd_project/features/files/domain/entities/file_entity.dart';
import 'package:smd_project/features/files/domain/repositories/file_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FileRepositoryImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  CollectionReference _getFilesCollection(String groupId) {
    return _firestore.collection('groups').doc(groupId).collection('files');
  }

  @override
  Future<String> uploadFile(
      String groupId, String path, List<int> bytes) async {
    final ref = _storage.ref().child('groups/$groupId/files/$path');
    await ref.putData(Uint8List.fromList(bytes));
    return await ref.getDownloadURL();
  }

  @override
  Future<void> deleteFile(String groupId, String path) async {
    await _storage.ref().child('groups/$groupId/files/$path').delete();
  }

  @override
  Future<void> createFileRecord(String groupId, FileEntity file) async {
    final fileModel = FileModel(
      id: file.id,
      name: file.name,
      type: file.type,
      size: file.size,
      uploadedAt: file.uploadedAt,
      uploadedBy: file.uploadedBy,
      downloadUrl: file.downloadUrl,
      description: file.description,
    );

    await _getFilesCollection(groupId).doc(file.id).set(fileModel.toMap());
  }

  @override
  Future<void> deleteFileRecord(String groupId, String fileId) async {
    await _getFilesCollection(groupId).doc(fileId).delete();
  }

  @override
  Future<FileEntity?> getFile(String groupId, String fileId) async {
    final doc = await _getFilesCollection(groupId).doc(fileId).get();
    if (!doc.exists) return null;
    return FileModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  @override
  Stream<List<FileEntity>> getGroupFiles(String groupId) {
    return _getFilesCollection(groupId)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                FileModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<List<FileEntity>> searchFiles(String groupId, String query) async {
    final queryLower = query.toLowerCase();
    final snapshot = await _getFilesCollection(groupId)
        .orderBy('uploadedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) =>
            FileModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .where((file) =>
            file.name.toLowerCase().contains(queryLower) ||
            (file.description?.toLowerCase().contains(queryLower) ?? false))
        .toList();
  }

  @override
  Stream<List<FileEntity>> getFilesByType(String groupId, String type) {
    return _getFilesCollection(groupId)
        .where('type', isEqualTo: type)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                FileModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<void> updateFileDescription(
      String groupId, String fileId, String description) async {
    await _getFilesCollection(groupId)
        .doc(fileId)
        .update({'description': description});
  }
}
