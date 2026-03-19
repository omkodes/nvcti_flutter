import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_forms.dart';
import '../events/forms_event.dart';
import '../states/forms_state.dart';

class FormsBloc extends Bloc<FormsEvent, FormsState> {
  final GetForms getForms;

  FormsBloc({required this.getForms}) : super(FormsInitial()) {
    on<FetchFormsEvent>((event, emit) async {
      emit(FormsLoading());
      try {
        final result = await getForms();
        emit(FormsLoaded(result));
      } catch (e) {
        emit(FormsError(e.toString()));
      }
    });
  }
}