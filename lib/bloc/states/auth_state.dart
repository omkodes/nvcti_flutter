import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
  @override
  List<Object> get props => [message];
}

class AuthLoggedOut extends AuthState {}

class AuthPasswordResetSuccess extends AuthState {
  final String message;
  AuthPasswordResetSuccess(this.message);
  @override
  List<Object> get props => [message];
}

// NEW: Fired after successful registration — user must verify email
class AuthRegistrationSuccess extends AuthState {
  final String message;
  AuthRegistrationSuccess(this.message);
  @override
  List<Object> get props => [message];
}

// NEW: Fired when user tries to log in without verifying email
class AuthEmailNotVerified extends AuthState {
  final String email;
  final String password;
  AuthEmailNotVerified({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

// NEW: Fired after resend verification email succeeds
class AuthVerificationEmailResent extends AuthState {
  final String message;
  AuthVerificationEmailResent(this.message);
  @override
  List<Object> get props => [message];
}
