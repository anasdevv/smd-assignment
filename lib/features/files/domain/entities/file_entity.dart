import 'package:equatable/equatable.dart';

class FileEntity extends Equatable {
  final String id;
  final String name;
  final String type;
  final int size;
  final DateTime uploadedAt;
  final String uploadedBy;
  final String downloadUrl;
  final String? description;

  const FileEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.uploadedAt,
    required this.uploadedBy,
    required this.downloadUrl,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        size,
        uploadedAt,
        uploadedBy,
        downloadUrl,
        description,
      ];
}
