// lib/domain/entities/club_detail.dart

class ClubMember {
  final String admNo;
  final String name;
  final String
  year; // "1st Year" | "2nd Year" | "3rd Year" | "Final Year" | "Super Final Year"

  const ClubMember({
    required this.admNo,
    required this.name,
    required this.year,
  });
}

class ClubProject {
  final String title;
  final String description;
  final String imgUrl;

  const ClubProject({
    required this.title,
    required this.description,
    required this.imgUrl,
  });
}

class ClubDetail {
  final String id;
  final String name;
  final String logoUrl;
  final String bannerUrl;
  final String description;

  // Key members
  final String fic;
  final String coFic;
  final String coordinator;
  final String techCoordinator;

  // All members by year
  final List<ClubMember> members;

  // Projects
  final List<ClubProject> projects;

  // Social links (empty string = hide icon)
  final String websiteUrl;
  final String linkedinUrl;
  final String instagramUrl;
  final String email;

  const ClubDetail({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.bannerUrl,
    required this.description,
    required this.fic,
    required this.coFic,
    required this.coordinator,
    required this.techCoordinator,
    this.members = const [],
    this.projects = const [],
    this.websiteUrl = '',
    this.linkedinUrl = '',
    this.instagramUrl = '',
    this.email = '',
  });
}
