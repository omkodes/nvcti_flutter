import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/form_entity.dart';

class FormModel extends FormEntity {
  const FormModel({
    required super.name,
    required super.downloadLink,
  });

  factory FormModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return FormModel(
      name: data?['formName'] ?? 'Unnamed Form',
      downloadLink: data?['formDownloadLink'] ?? '',
    );
  }
}
