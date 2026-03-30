import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/club.dart';

class ClubModel extends Club {
  const ClubModel({
    required super.id,
    required super.clubId,
    required super.name,
    required super.logoPath,
  });

  factory ClubModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClubModel(
      id: doc.id,
      clubId: data['clubId'] ?? '', // e.g. "C007"
      name: data['clubName'] ?? 'No Name',
      logoPath: data['logoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'clubId': clubId, 'name': name, 'logoPath': logoPath};
  }
}
