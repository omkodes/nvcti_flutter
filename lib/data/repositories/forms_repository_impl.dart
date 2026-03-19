import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/form_entity.dart';
import '../../domain/repositories/form_repository.dart';
import '../models/form_model.dart';

class FormsRepositoryImpl implements FormsRepository {
  final FirebaseFirestore firestore;

  FormsRepositoryImpl({required this.firestore});

  @override
  Future<List<FormEntity>> getForms() async {
    try {
      final snapshot = await firestore.collection("forms").get();
      return snapshot.docs
          .map((doc) => FormModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception("Error fetching forms: $e");
    }
  }
}