import 'package:flutter/material.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jhoddadzixqhzlbhmjcs.supabase.co',
    anonKey: 'sb_publishable_MiPHnHXJiWSxX36U38x42A__QZN3irB',
  );

  runApp(const GromotionApp());
}

class GromotionApp extends StatelessWidget {
  const GromotionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: '/',
    );
  }
}