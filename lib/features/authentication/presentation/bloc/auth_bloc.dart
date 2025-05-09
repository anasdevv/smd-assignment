import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:smd_project/features/authentication/domain/repositories/auth_repository.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_event.dart';
import 'package:smd_project/features/authentication/presentation/bloc/auth_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<FetchUser>(_onFetchUser);
    on<UpdateProfile>(_onUpdateProfile);
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String;
      switch (type) {
        case 'AuthInitial':
          return AuthInitial.fromJson(json);
        case 'AuthLoading':
          return AuthLoading.fromJson(json);
        case 'Authenticated':
          return Authenticated.fromJson(json);
        case 'Unauthenticated':
          return Unauthenticated.fromJson(json);
        case 'AuthError':
          return AuthError.fromJson(json);
        default:
          return AuthInitial();
      }
    } catch (e) {
      return AuthInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.toJson();
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signUpWithEmailAndPassword(
        event.email,
        event.password,
        event.name,
      );
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepository.sendPasswordResetEmail(event.email);
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onFetchUser(
    FetchUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(AuthError("User not found"));
      }
    } catch (e) {
      emit(AuthError("Failed to fetch User"));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      String? photoUrl;
      if (event.photoFile != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        final filePath = 'profile-pictures/$fileName';

        // Upload file to Supabase Storage
        await supabase.Supabase.instance.client.storage
            .from('profile-pictures')
            .uploadBinary(
              filePath,
              event.photoFile!.bytes!,
              fileOptions: const supabase.FileOptions(
                contentType: 'image/jpeg',
              ),
            );

        // Get public URL
        photoUrl = supabase.Supabase.instance.client.storage
            .from('profile-pictures')
            .getPublicUrl(filePath);
      }

      await authRepository.updateUserProfile(event.displayName, photoUrl);
      final updatedUser = await authRepository.getCurrentUser();
      if (updatedUser != null) {
        emit(Authenticated(updatedUser));
      } else {
        emit(AuthError("Failed to update profile"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
