import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
// Achievements
import 'package:nvcti/bloc/bloc/achievements_bloc.dart';
// Auth
import 'package:nvcti/bloc/bloc/auth_bloc.dart';
// Bookings & Users
import 'package:nvcti/bloc/bloc/booking_bloc.dart';
// Clubs
import 'package:nvcti/bloc/bloc/club_bloc.dart';
// Forms
import 'package:nvcti/bloc/bloc/forms_bloc.dart';
// Inventory
import 'package:nvcti/bloc/bloc/inventory_bloc.dart';
import 'package:nvcti/bloc/bloc/notificaiton_bloc.dart';
// Notifications (New)
// Projects
import 'package:nvcti/bloc/bloc/projects_bloc.dart';
import 'package:nvcti/data/datasources/remote_datasource/auth_remote_data_source.dart';
import 'package:nvcti/data/datasources/remote_datasource/club_remote_data_source.dart';
import 'package:nvcti/data/datasources/remote_datasource/inventory_remote_data_source.dart';
// Notifications
import 'package:nvcti/data/datasources/remote_datasource/notification_remote_data_source.dart';
import 'package:nvcti/data/repositories/achievements_repository_impl.dart';
import 'package:nvcti/data/repositories/auth_repository_impl.dart';
import 'package:nvcti/data/repositories/booking_repository_impl.dart';
import 'package:nvcti/data/repositories/club_repository_impl.dart';
import 'package:nvcti/data/repositories/forms_repository_impl.dart';
import 'package:nvcti/data/repositories/notificaiton_repository_impl.dart';
import 'package:nvcti/data/repositories/projects_repository_impl.dart';
import 'package:nvcti/data/repositories/user_repository_impl.dart';
import 'package:nvcti/domain/repositories/achievements_repository.dart';
import 'package:nvcti/domain/repositories/auth_repository.dart';
import 'package:nvcti/domain/repositories/booking_repository.dart';
import 'package:nvcti/domain/repositories/club_repository.dart';
import 'package:nvcti/domain/repositories/form_repository.dart';
import 'package:nvcti/domain/repositories/notificaiton_repository.dart';
import 'package:nvcti/domain/repositories/projects_repository.dart';
import 'package:nvcti/domain/repositories/user_repository.dart';
import 'package:nvcti/domain/usecases/ForgotPasswordUseCase.dart';
import 'package:nvcti/domain/usecases/LoginUseCase.dart';
import 'package:nvcti/domain/usecases/RegisterUseCase.dart';
import 'package:nvcti/domain/usecases/add_booking.dart';
import 'package:nvcti/domain/usecases/get_achievements.dart';
import 'package:nvcti/domain/usecases/get_bookings.dart';
import 'package:nvcti/domain/usecases/get_clubs.dart';
import 'package:nvcti/domain/usecases/get_forms.dart';
import 'package:nvcti/domain/usecases/get_notificaitons.dart';
import 'package:nvcti/domain/usecases/get_projects.dart';
import 'package:nvcti/domain/usecases/logout_usecase.dart';
import 'package:nvcti/domain/usecases/resendVerificationEmailUseCase.dart';

class Injector {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> setup() async {
    // --- External ---
    _getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
    _getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

    // --- Data Sources ---
    _getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(firebaseAuth: _getIt<FirebaseAuth>()),
    );
    _getIt.registerLazySingleton<ClubRemoteDataSource>(
      () => ClubRemoteDataSourceImpl(firestore: _getIt<FirebaseFirestore>()),
    );
    _getIt.registerLazySingleton<InventoryRemoteDataSource>(
      () =>
          InventoryRemoteDataSourceImpl(firestore: _getIt<FirebaseFirestore>()),
    );
    _getIt.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(_getIt<FirebaseFirestore>()),
    );

    // --- Repositories ---
    _getIt.registerLazySingleton<AuthRepository>(
      () =>
          AuthRepositoryImpl(remoteDataSource: _getIt<AuthRemoteDataSource>()),
    );
    _getIt.registerLazySingleton<ClubRepository>(
      () =>
          ClubRepositoryImpl(remoteDataSource: _getIt<ClubRemoteDataSource>()),
    );
    _getIt.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(),
    );
    _getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(firestore: _getIt<FirebaseFirestore>()),
    );
    _getIt.registerLazySingleton<AchievementsRepository>(
      () => AchievementsRepositoryImpl(firestore: _getIt<FirebaseFirestore>()),
    );
    _getIt.registerLazySingleton<FormsRepository>(
      () => FormsRepositoryImpl(firestore: _getIt<FirebaseFirestore>()),
    );
    _getIt.registerLazySingleton<ProjectsRepository>(
      () => ProjectsRepositoryImpl(firestore: _getIt<FirebaseFirestore>()),
    );
    _getIt.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(_getIt<NotificationRemoteDataSource>()),
    );

    // --- Use Cases ---
    _getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCase(_getIt<AuthRepository>()),
    );
    _getIt.registerLazySingleton<LogoutUseCase>(
      () => LogoutUseCase(_getIt<AuthRepository>()),
    );
    _getIt.registerLazySingleton<RegisterUseCase>(
      () => RegisterUseCase(_getIt<AuthRepository>()),
    );
    _getIt.registerLazySingleton<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(_getIt<AuthRepository>()),
    );
    _getIt.registerLazySingleton<ResendVerificationEmailUseCase>(
      () => ResendVerificationEmailUseCase(_getIt<AuthRepository>()),
    );
    _getIt.registerLazySingleton<GetClubs>(
      () => GetClubs(_getIt<ClubRepository>()),
    );
    _getIt.registerLazySingleton<GetBookings>(
      () => GetBookings(_getIt<BookingRepository>()),
    );
    _getIt.registerLazySingleton<AddBooking>(
      () => AddBooking(_getIt<BookingRepository>()),
    );
    _getIt.registerLazySingleton<GetAchievements>(
      () => GetAchievements(_getIt<AchievementsRepository>()),
    );
    _getIt.registerLazySingleton<GetForms>(
      () => GetForms(_getIt<FormsRepository>()),
    );
    _getIt.registerLazySingleton<GetProjects>(
      () => GetProjects(_getIt<ProjectsRepository>()),
    );
    _getIt.registerLazySingleton<GetNotifications>(
      () => GetNotifications(_getIt<NotificationRepository>()),
    );

    // --- Blocs ---
    _getIt.registerFactory<AuthBloc>(
      () => AuthBloc(
        logoutUseCase: _getIt<LogoutUseCase>(),
        loginUseCase: _getIt<LoginUseCase>(),
        registerUseCase: _getIt<RegisterUseCase>(),
        forgotPasswordUseCase: _getIt<ForgotPasswordUseCase>(),
        resendVerificationEmailUseCase:
            _getIt<ResendVerificationEmailUseCase>(),
      ),
    );
    _getIt.registerFactory<ClubBloc>(
      () => ClubBloc(repository: _getIt<ClubRepository>()),
    );
    _getIt.registerFactory<InventoryBloc>(
      () => InventoryBloc(dataSource: _getIt<InventoryRemoteDataSource>()),
    );
    _getIt.registerFactory<BookingBloc>(
      () => BookingBloc(
        getBookings: _getIt<GetBookings>(),
        addBooking: _getIt<AddBooking>(),
        userRepository: _getIt<UserRepository>(),
      ),
    );
    _getIt.registerFactory<AchievementsBloc>(
      () => AchievementsBloc(getAchievements: _getIt<GetAchievements>()),
    );
    _getIt.registerFactory<FormsBloc>(
      () => FormsBloc(getForms: _getIt<GetForms>()),
    );
    _getIt.registerFactory<ProjectsBloc>(
      () => ProjectsBloc(getProjects: _getIt<GetProjects>()),
    );
    _getIt.registerFactory<NotificationBloc>(
      () => NotificationBloc(getNotifications: _getIt<GetNotifications>()),
    );
  }

  static T get<T extends Object>() => _getIt.get<T>();
}
