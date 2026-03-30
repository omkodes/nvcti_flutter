// lib/data/datasources/remote_datasource/club_detail_remote_data_source.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/club_detail.dart';
import '../../models/club_detail_model.dart';

abstract class ClubDetailRemoteDataSource {
  Future<ClubDetail> fetchClubDetail(String clubId);
}

class ClubDetailRemoteDataSourceImpl implements ClubDetailRemoteDataSource {
  final FirebaseFirestore firestore;

  ClubDetailRemoteDataSourceImpl({required this.firestore});

  @override
  Future<ClubDetail> fetchClubDetail(String clubId) async {
    try {
      // All club data is stored flat inside TechClubData/<clubId>
      final doc = await firestore.collection('TechClubData').doc(clubId).get();

      if (!doc.exists) throw Exception('Club not found: $clubId');

      return ClubDetailModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch club detail: $e');
    }
  }
}
