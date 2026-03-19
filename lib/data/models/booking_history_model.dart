import '../../domain/entities/booking_history.dart';

class BookingHistoryModel extends BookingHistory {
  const BookingHistoryModel({
    required super.userId,
    required super.userName,
    required super.userAdmNo,
    required super.userEmail,
    required super.userContact,
    required super.resourceType,
    super.resourceName,
    required super.resourceFromDate,
    required super.resourceToDate,
    required super.resourceFromTime,
    required super.resourceToTime,
    required super.status,
  });

  factory BookingHistoryModel.fromJson(Map<String, dynamic> json) {
    return BookingHistoryModel(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userAdmNo: json['userAdmNo'] ?? '',
      userEmail: json['userEmail'] ?? '',
      userContact: json['userContact'] ?? '',
      resourceType: json['resourceType'] ?? '',
      resourceName: json['resourceName'],
      resourceFromDate: json['resourceFromDate'] ?? '',
      resourceToDate: json['resourceToDate'] ?? '',
      resourceFromTime: json['resourceFromTime'] ?? '',
      resourceToTime: json['resourceToTime'] ?? '',
      status: json['status'] ?? '',
    );
  }
}