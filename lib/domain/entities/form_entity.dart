import 'package:equatable/equatable.dart';

class FormEntity extends Equatable {
  final String name;
  final String downloadLink;

  const FormEntity({
    required this.name,
    required this.downloadLink,
  });

  @override
  List<Object?> get props => [name, downloadLink];
}