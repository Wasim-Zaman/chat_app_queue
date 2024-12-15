part of 'auth_provider.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final ApiResponse response;
  const AuthSuccess(this.response);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
