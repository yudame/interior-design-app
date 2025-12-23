import 'dart:async';

import '../../../../core/utils/result.dart';
import '../models/auth_user.dart';

abstract class AuthService {
  Stream<AuthUser?> get authStateChanges;
  Future<AuthUser?> get currentUser;

  Future<Result<AuthUser>> signInWithEmail(String email, String password);
  Future<Result<AuthUser>> signUpWithEmail(String email, String password);
  Future<Result<AuthUser>> signInWithApple();
  Future<Result<AuthUser>> signInAnonymously();
  Future<Result<AuthUser>> linkAnonymousToEmail(String email, String password);
  Future<void> signOut();
}
