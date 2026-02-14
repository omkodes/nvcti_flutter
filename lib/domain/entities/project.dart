import 'package:equatable/equatable.dart';

class Project extends Equatable {
  final String title;
  final String description;
  final String imgUrl;
  final String club;

  const Project({
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.club,
  });

  @override
  List<Object?> get props => [title, description, imgUrl, club];
}