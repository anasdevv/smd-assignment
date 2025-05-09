import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpRequested(this.email, this.password, this.name);

  @override
  List<Object> get props => [email, password, name];
}

class SignOutRequested extends AuthEvent {}

class ResetPasswordRequested extends AuthEvent {
  final String email;

  const ResetPasswordRequested(this.email);

  @override
  List<Object> get props => [email];
}

class CheckAuthStatus extends AuthEvent {}

class FetchUser extends AuthEvent {}

class UpdateProfile extends AuthEvent {
  final String displayName;
  final PlatformFile? photoFile;

  const UpdateProfile({
    required this.displayName,
    this.photoFile,
  });

  @override
  List<Object?> get props => [displayName, photoFile];
}
