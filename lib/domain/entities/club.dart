class Club {
  final String id; // Firestore auto-generated doc ID
  final String clubId; // e.g. "C007" — used to fetch detail
  final String name;
  final String logoPath;

  const Club({
    required this.id,
    required this.clubId,
    required this.name,
    required this.logoPath,
  });
}
