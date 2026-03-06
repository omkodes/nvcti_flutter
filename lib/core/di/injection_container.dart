import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:nvcti/bloc/bloc/club_bloc.dart';
import 'package:nvcti/data/datasources/remote_datasource/club_remote_data_source.dart';
import 'package:nvcti/data/repositories/club_repository_impl.dart';
import 'package:nvcti/domain/repositories/club_repository.dart';
import 'package:nvcti/domain/usecases/get_clubs.dart';

class Injector {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> setup() async {
    // --- External ---
    _getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );

    // --- Data Sources ---
    _getIt.registerLazySingleton<ClubRemoteDataSource>(
      () => ClubRemoteDataSourceImpl(firestore: _getIt<FirebaseFirestore>()),
    );

    // --- Repositories ---
    _getIt.registerLazySingleton<ClubRepository>(
      () =>
          ClubRepositoryImpl(remoteDataSource: _getIt<ClubRemoteDataSource>()),
    );

    // --- Use Cases ---
    _getIt.registerLazySingleton<GetClubs>(
      () => GetClubs(_getIt<ClubRepository>()),
    );

    // --- Blocs ---
    // Factory is used for Blocs so a new instance is created when needed
    _getIt.registerFactory<ClubBloc>(
      () => ClubBloc(repository: _getIt<ClubRepository>()),
    );
  }

  // Helper to access instances easily
  static T get<T extends Object>() => _getIt.get<T>();
}
