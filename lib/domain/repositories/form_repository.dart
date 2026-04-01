import '../entities/form_entity.dart';

abstract class FormsRepository {
  Future<List<FormEntity>> getForms();
}
