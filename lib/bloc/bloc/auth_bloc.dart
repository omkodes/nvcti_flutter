import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nvcti/bloc/events/auth_event.dart';
import 'package:nvcti/bloc/states/auth_state.dart';
import 'package:nvcti/domain/usecases/ForgotPasswordUseCase.dart';
import 'package:nvcti/domain/usecases/LoginUseCase.dart';
import 'package:nvcti/domain/usecases/RegisterUseCase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.forgotPasswordUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await loginUseCase(event.email, event.password);
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<ForgotPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await forgotPasswordUseCase(
          event.email,
        ); // Assuming you wired the use case
        emit(
          AuthPasswordResetSuccess(
            "Password reset email sent. Check your inbox.",
          ),
        );
      } catch (e) {
        emit(AuthError(e.toString().replaceAll('Exception: ', '')));
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
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
