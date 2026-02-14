import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Achievement extends Equatable {
  final String title;
  final String description;
  final String imgUrl;
  final String club;

  const Achievement({
    required this.title,
    required this.description,
    required this.imgUrl,
    required this.club,
  });

  @override
  List<Object?> get props => [title, description, imgUrl, club];
}