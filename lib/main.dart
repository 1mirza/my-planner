import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:my_planner_pro/config/router/app_router.dart';
import 'package:my_planner_pro/config/theme/app_theme.dart';
import 'package:my_planner_pro/data/models/task_model.dart';
import 'package:my_planner_pro/presentation/providers/task_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // <-- این خط را اضافه کنید

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [TaskModelSchema],
    directory: dir.path,
  );

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'My Planner Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // -->> شروع تغییرات برای راست‌چین کردن <<--
      locale: const Locale('fa', 'IR'), // تنظیم زبان فارسی
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', 'IR'), // پشتیبانی از فارسی
      ],
      // -->> پایان تغییرات <<--

      routerConfig: appRouter,
    );
  }
}
