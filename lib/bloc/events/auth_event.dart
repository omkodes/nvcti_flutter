import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

class LogoutRequested extends AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String mobileNumber;

  RegisterRequested(this.name, this.email, this.password, this.mobileNumber);

  @override
  List<Object> get props => [name, email, password, mobileNumber];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;
  ForgotPasswordRequested(this.email);
  @override
  List<Object> get props => [email];
}

// NEW: Resend verification email event
class ResendVerificationEmailRequested extends AuthEvent {
  final String email;
  final String password;
  ResendVerificationEmailRequested({
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [email, password];
}
