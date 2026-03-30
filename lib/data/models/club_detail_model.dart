// lib/data/models/club_detail_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/club_detail.dart';

class ClubMemberModel extends ClubMember {
  const ClubMemberModel({
    required super.admNo,
    required super.name,
    required super.year,
  });

  factory ClubMemberModel.fromMap(Map<String, dynamic> map) {
    return ClubMemberModel(
      admNo: map['admNo'] ?? '',
      name: map['name'] ?? '',
      year: map['year'] ?? '',
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

  factory ClubDetailModel.fromFirestore(
    DocumentSnapshot doc,
    List<ClubMember> members,
    List<ClubProject> projects,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    return ClubDetailModel(
      id: doc.id,
      name: data['clubName'] ?? '',
      logoUrl: data['logoUrl'] ?? '',
      bannerUrl: data['bannerUrl'] ?? '',
      description: data['clubDescription'] ?? '',
      fic: data['fic'] ?? '',
      coFic: data['coFic'] ?? '',
      coordinator: data['coordinator'] ?? '',
      techCoordinator: data['techCoordinator'] ?? '',
      members: members,
      projects: projects,
      websiteUrl: data['websiteUrl'] ?? '',
      linkedinUrl: data['linkedinUrl'] ?? '',
      instagramUrl: data['instagramUrl'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
