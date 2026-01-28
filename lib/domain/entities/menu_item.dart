class MenuItem {
  final String title;
  final String imagePath; // Path to your asset (e.g., 'assets/icons/clubs.png')
  final String route; // Navigation route

  const MenuItem({
    required this.title,
    required this.imagePath,
    required this.route,
  });
}
