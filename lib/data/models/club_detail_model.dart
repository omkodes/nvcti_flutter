// lib/data/models/club_detail_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/club_detail.dart';

/// Parses a member map from one of the flat year-arrays in Firestore.
/// Firestore fields: studentID, studentName, studentEmail
class ClubMemberModel extends ClubMember {
  const ClubMemberModel({
    required super.studentID,
    required super.studentName,
    required super.studentEmail,
    required super.year,
  });

  factory ClubMemberModel.fromMap(Map<String, dynamic> map, String year) {
    return ClubMemberModel(
      studentID: map['studentID'] ?? '',
      studentName: map['studentName'] ?? '',
      studentEmail: map['studentEmail'] ?? '',
      year: year,
    );
  }
}

class ClubProjectModel extends ClubProject {
  const ClubProjectModel({
    required super.title,
    required super.description,
    required super.imgUrl,
  });

  factory ClubProjectModel.fromMap(Map<String, dynamic> map) {
    return ClubProjectModel(
      title: map['projectTitle'] ?? '',
      description: map['projectDescription'] ?? '',
      imgUrl: map['projectImgUrl'] ?? '',
    );
  }
}

class ClubDetailModel extends ClubDetail {
  const ClubDetailModel({
    required super.id,
    required super.name,
    required super.logoUrl,
    required super.bannerUrl,
    required super.description,
    required super.fic,
    required super.coFic,
    required super.coordinator,
    required super.techCoordinator,
    super.members,
    super.projects,
    super.websiteUrl,
    super.linkedinUrl,
    super.instagramUrl,
    super.email,
  });

  /// Parses a flat Firestore document from TechClubData/<clubId>.
  ///
  /// Member arrays in Firestore:
  ///   clubMemberFirstYear    → "1st Year"
  ///   clubMemberSecondYear   → "2nd Year"
  ///   clubMemberThirdYear    → "3rd Year"
  ///   clubMemberFinalYear    → "Final Year"
  ///   clubMemberSuperFinalYear → "Super Final Year"
  ///
  /// Project array: recentProjects
  factory ClubDetailModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // ── Parse members from flat arrays ──────────────────────────
    final yearMap = {
      'clubMemberFirstYear': '1st Year',
      'clubMemberSecondYear': '2nd Year',
      'clubMemberThirdYear': '3rd Year',
      'clubMemberFinalYear': '4th Year (Final Year)',
      'clubMemberSuperFinalYear': '5th Year (Super Final)',
    };

    final members = <ClubMember>[];
    for (final entry in yearMap.entries) {
      final rawList = data[entry.key];
      if (rawList is List) {
        for (final item in rawList) {
          if (item is Map<String, dynamic>) {
            members.add(ClubMemberModel.fromMap(item, entry.value));
          }
        }
      }
    }

    // ── Parse projects ───────────────────────────────────────────
    final rawProjects = data['recentProjects'];
    final projects = <ClubProject>[];
    if (rawProjects is List) {
      for (final p in rawProjects) {
        if (p is Map<String, dynamic>) {
          projects.add(ClubProjectModel.fromMap(p));
        }
      }
    }

    return ClubDetailModel(
      id: doc.id,
      name: data['clubName'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
      bannerUrl: data['bannerUrl'] ?? '',
      description: data['clubDescription'] ?? '',
      fic: data['clubFIC'] ?? '',
      coFic: data['clubCoFIC'] ?? '',
      coordinator: data['clubCoordi'] ?? '',
      techCoordinator: data['clubTechCoordi'] ?? '',
      members: members,
      projects: projects,
      websiteUrl: data['websiteUrl'] ?? '',
      linkedinUrl: data['linkedinUrl'] ?? '',
      instagramUrl: data['instaUrl'] ?? '',
      email: data['mailId'] ?? '',
    );
  }
}
