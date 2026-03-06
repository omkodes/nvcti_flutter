import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nvcti/data/models/club_model.dart';

abstract class ClubRemoteDataSource {
  Future<List<ClubModel>> fetchClubs();
}

class ClubRemoteDataSourceImpl implements ClubRemoteDataSource {
  final FirebaseFirestore firestore;

  ClubRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ClubModel>> fetchClubs() async {
    try {
      final querySnapshot = await firestore.collection('clubs').get();
      return querySnapshot.docs
          .map((doc) => ClubModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception("problem to fetch the data $e");
    }
  }
}
