import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nvcti/bloc/events/auth_event.dart';
import 'package:nvcti/bloc/states/auth_state.dart';
import 'package:nvcti/domain/usecases/ForgotPasswordUseCase.dart';
import 'package:nvcti/domain/usecases/LoginUseCase.dart';
import 'package:nvcti/domain/usecases/RegisterUseCase.dart';
import 'package:nvcti/domain/usecases/logout_usecase.dart';
import 'package:nvcti/domain/usecases/resendVerificationEmailUseCase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResendVerificationEmailUseCase resendVerificationEmailUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
    required this.resendVerificationEmailUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await loginUseCase(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        final message = e.toString().replaceAll('Exception: ', '');
        // Check if this is an email-not-verified error
        if (message.contains('verify your email')) {
          emit(
            AuthEmailNotVerified(email: event.email, password: event.password),
          );
        } else {
          emit(AuthError(message));
        }
      }
    });

    on<ForgotPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await forgotPasswordUseCase(event.email);
        emit(
          AuthPasswordResetSuccess(
            "Password reset email sent. Check your inbox.",
          ),
        );
      } catch (e) {
        emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await logoutUseCase();
        emit(AuthLoggedOut()); // Success state
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await registerUseCase(
          event.name,
          event.email,
          event.password,
          event.mobileNumber,
        );
        // NEW: Emit registration success with a message instead of AuthSuccess
        emit(
          AuthRegistrationSuccess(
            'Registration successful! A verification email has been sent to ${event.email}. Please verify before logging in.',
          ),
        );
      } catch (e) {
        emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<ResendVerificationEmailRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await resendVerificationEmailUseCase(event.email, event.password);
        emit(
          AuthVerificationEmailResent(
            'Verification email resent. Please check your inbox.',
          ),
        );
      } catch (e) {
        emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
