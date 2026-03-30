import 'package:nvcti/data/datasources/remote_datasource/notification_remote_data_source.dart';
import 'package:nvcti/domain/entities/notificaiton_item.dart';
import 'package:nvcti/domain/repositories/notificaiton_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationItem>> getNotifications() async {
    return await remoteDataSource.getNotifications();
  }
}
