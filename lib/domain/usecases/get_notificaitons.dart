import 'package:nvcti/domain/entities/notificaiton_item.dart';
import 'package:nvcti/domain/repositories/notificaiton_repository.dart';

class GetNotifications {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  Future<List<NotificationItem>> call() async {
    return await repository.getNotifications();
  }
}
