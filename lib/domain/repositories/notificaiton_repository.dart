import 'package:nvcti/domain/entities/notificaiton_item.dart';

abstract class NotificationRepository {
  Future<List<NotificationItem>> getNotifications();
}
