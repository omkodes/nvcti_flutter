import 'package:equatable/equatable.dart';

class BookingHistory extends Equatable {
  final String userId;
  final String userName;
  final String userAdmNo;
  final String userEmail;
  final String userContact;
  final String resourceType;
  final String? resourceName;
  final String resourceFromDate;
  final String resourceToDate;
  final String resourceFromTime;
  final String resourceToTime;
  final String status;

  const BookingHistory({
    required this.userId,
    required this.userName,
    required this.userAdmNo,
    required this.userEmail,
    required this.userContact,
    required this.resourceType,
    this.resourceName,
    required this.resourceFromDate,
    required this.resourceToDate,
    required this.resourceFromTime,
    required this.resourceToTime,
    required this.status,
  });

  @override
  List<Object?> get props => [userId, resourceType, resourceFromDate, status];
}
