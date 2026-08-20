// File: lib/main.dart
// Purpose: Application entry point, service initialization, and routing setup for The Realty Bazaar.

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'app/app_routes.dart';
import 'app/app_theme.dart';
import 'app/app_strings.dart';
import 'providers/form/form_provider.dart';
import 'core/services/storage_service.dart';

void main() async {
  // Remove hash (#) from web url routing
  usePathUrlStrategy();

  // Ensure Flutter engine bindings are loaded
  WidgetsFlutterBinding.ensureInitialized();

  // Lock device orientation to portrait mode only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 1. Read Supabase credentials from compile-time environment defines
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  // 2. Initialize Supabase
  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    try {
      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
      debugPrint('Supabase initialized successfully!');
    } catch (e) {
      debugPrint('Failed to initialize Supabase: $e');
    }
  } else {
    debugPrint(
      'Supabase credentials missing or invalid in environment defines',
    );
  }

  // 3. Initialize storage service via GetX Dependency Injection
  try {
    await Get.putAsync(() => StorageService().init());
    debugPrint('StorageService initialized successfully!');
  } catch (e) {
    debugPrint('Failed to initialize StorageService: $e');
  }

  // 4. Run the application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormProvider()),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        routerConfig: AppRoutes.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
