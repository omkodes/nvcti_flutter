import 'package:flutter/material.dart';
import 'package:nvcti/core/di/injection_container.dart';
import 'package:nvcti/core/navigation/app_router.dart';
import 'package:nvcti/presentation/common/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injector.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
