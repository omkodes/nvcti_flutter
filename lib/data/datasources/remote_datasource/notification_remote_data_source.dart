import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nvcti/data/models/notificaiton_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final snapshot = await firestore
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => NotificationModel.fromFirestore(doc))
        .toList();
  }
}
