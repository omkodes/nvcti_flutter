import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/club.dart';

class ClubModel extends Club {
  const ClubModel({
    required super.id,
    required super.name,
    required super.logoPath,
  });

  factory ClubModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ClubModel(
      id: doc.id,
      name: data['clubName'] ?? 'No Name',
      logoPath: data['logoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'logoPath': logoPath};
  }
}
