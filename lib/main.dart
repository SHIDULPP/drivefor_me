import 'package:driveforme_user/src/data/constants/colour_constants.dart';
import 'package:driveforme_user/src/data/providers/screen_size_provider.dart';
import 'package:driveforme_user/src/data/router/router.dart' as router;
import 'package:driveforme_user/src/data/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: router.generateRoute,
      initialRoute: 'Splash',
      title: 'Drive For Me',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: kScreenBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
          surface: kScreenBg,
        ),
        fontFamily: 'ClashGrotesk',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
          ),
          displayMedium: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
          ),
          displaySmall: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
          ),
          titleMedium: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w400,
          ),
          labelLarge: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w400,
          ),
          labelMedium: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w400,
          ),
          labelSmall: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w400,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: kTextColor,
          ),
        ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return ScreenSizeScope(child: child!);
      },
    );
  }
}
