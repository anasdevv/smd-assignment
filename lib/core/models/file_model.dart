import 'package:cloud_firestore/cloud_firestore.dart';

class FileModel {
  final String id;
  final String name;
  final String type;
  final int size;
  final DateTime uploadedAt;
  final String uploadedBy;
  final String downloadUrl;
  final String? description;

  const FileModel({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.uploadedAt,
    required this.uploadedBy,
    required this.downloadUrl,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'size': size,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'uploadedBy': uploadedBy,
      'downloadUrl': downloadUrl,
      'description': description,
    };
  }

  factory FileModel.fromMap(String id, Map<String, dynamic> map) {
    return FileModel(
      id: id,
      name: map['name'] as String,
      type: map['type'] as String,
      size: map['size'] as int,
      uploadedAt: (map['uploadedAt'] as Timestamp).toDate(),
      uploadedBy: map['uploadedBy'] as String,
      downloadUrl: map['downloadUrl'] as String,
      description: map['description'] as String?,
    );
  }

  FileModel copyWith({
    String? name,
    String? type,
    int? size,
    DateTime? uploadedAt,
    String? uploadedBy,
    String? downloadUrl,
    String? description,
  }) {
    return FileModel(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      size: size ?? this.size,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      description: description ?? this.description,
    );
  }
}
