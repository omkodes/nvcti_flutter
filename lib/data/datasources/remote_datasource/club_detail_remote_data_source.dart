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
      // Fetch main club document
      final doc = await firestore.collection('TechClubs').doc(clubId).get();
      if (!doc.exists) throw Exception('Club not found');

      // Fetch members sub-collection
      final membersSnap = await firestore
          .collection('TechClubs')
          .doc(clubId)
          .collection('members')
          .get();
      final members = membersSnap.docs
          .map((d) => ClubMemberModel.fromMap(d.data()))
          .toList();

      // Fetch projects sub-collection
      final projectsSnap = await firestore
          .collection('TechClubs')
          .doc(clubId)
          .collection('projects')
          .get();
      final projects = projectsSnap.docs
          .map((d) => ClubProjectModel.fromMap(d.data()))
          .toList();

      return ClubDetailModel.fromFirestore(doc, members, projects);
    } catch (e) {
      throw Exception('Failed to fetch club detail: $e');
    }
  }
}
