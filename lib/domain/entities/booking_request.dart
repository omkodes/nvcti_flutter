import 'package:equatable/equatable.dart';

class BookingRequest extends Equatable {
  final String userId;
  final String userName;
  final String userAdmNo;
  final String userEmail;
  final String userContact;
  final String resourceType;
  final String resourceName;
  final String resourceFromDate;
  final String resourceToDate;
  final String resourceFromTime;
  final String resourceToTime;

  const BookingRequest({
    required this.userId,
    required this.userName,
    required this.userAdmNo,
    required this.userEmail,
    required this.userContact,
    required this.resourceType,
    required this.resourceName,
    required this.resourceFromDate,
    required this.resourceToDate,
    required this.resourceFromTime,
    required this.resourceToTime,
  });

  // Helper to convert to JSON for the API call
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userAdmNo': userAdmNo,
      'userEmail': userEmail,
      'userContact': userContact,
      'resourceType': resourceType,
      'resourceName': resourceName,
      'resourceFromDate': resourceFromDate,
      'resourceToDate': resourceToDate,
      'resourceFromTime': resourceFromTime,
      'resourceToTime': resourceToTime,
    };
  }

  @override
  List<Object?> get props => [userId, resourceType, resourceFromDate];
}
