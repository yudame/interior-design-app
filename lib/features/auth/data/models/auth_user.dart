import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

@freezed
class AuthUser with _$AuthUser {
  const AuthUser._();

  const factory AuthUser({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default(false) bool isAnonymous,
    required DateTime createdAt,
    DateTime? lastSignInAt,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);

  bool get hasDisplayName => displayName != null && displayName!.isNotEmpty;
}
