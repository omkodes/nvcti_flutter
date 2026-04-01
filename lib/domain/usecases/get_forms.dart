import '../entities/form_entity.dart';
import '../repositories/form_repository.dart';

class GetForms {
  final FormsRepository repository;

  GetForms(this.repository);

  Future<List<FormEntity>> call() async {
    return await repository.getForms();
  }
}
