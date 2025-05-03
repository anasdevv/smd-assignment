import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import '../models/file_model.dart';

class FileRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference _getFilesCollection(String groupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('files');
  }

  Future<String> uploadFile(
      String groupId, String path, Uint8List bytes) async {
    final ref = _storage.ref().child('groups/$groupId/files/$path');
    await ref.putData(bytes);
    return await ref.getDownloadURL();
  }

  Future<void> deleteFile(String groupId, String path) async {
    await _storage.ref().child('groups/$groupId/files/$path').delete();
  }

  Future<void> createFileRecord(String groupId, FileModel file) async {
    await _getFilesCollection(groupId).doc(file.id).set(file.toMap());
  }

  Future<void> deleteFileRecord(String groupId, String fileId) async {
    await _getFilesCollection(groupId).doc(fileId).delete();
  }

  Future<FileModel?> getFile(String groupId, String fileId) async {
    final doc = await _getFilesCollection(groupId).doc(fileId).get();
    if (!doc.exists) return null;
    return FileModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  Stream<List<FileModel>> getGroupFiles(String groupId) {
    return _getFilesCollection(groupId)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                FileModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<List<FileModel>> searchFiles(String groupId, String query) async {
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

  Stream<List<FileModel>> getFilesByType(String groupId, String type) {
    return _getFilesCollection(groupId)
        .where('type', isEqualTo: type)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                FileModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateFileDescription(
      String groupId, String fileId, String description) async {
    await _getFilesCollection(groupId)
        .doc(fileId)
        .update({'description': description});
  }
}
