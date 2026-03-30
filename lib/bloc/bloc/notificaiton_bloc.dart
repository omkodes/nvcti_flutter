import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nvcti/bloc/events/notificaiton_event.dart';
import 'package:nvcti/bloc/states/notificaiton_state.dart';
import 'package:nvcti/domain/usecases/get_notificaitons.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications getNotifications;

  NotificationBloc({required this.getNotifications})
    : super(NotificationInitial()) {
    on<LoadNotificationsEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications = await getNotifications();
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
  }
}
