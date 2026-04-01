import '../../domain/entities/form_entity.dart';

abstract class FormsState {}

class FormsInitial extends FormsState {}

class FormsLoading extends FormsState {}

class FormsLoaded extends FormsState {
  final List<FormEntity> forms;
  FormsLoaded(this.forms);
}

class FormsError extends FormsState {
  final String message;
  FormsError(this.message);
}
