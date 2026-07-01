import 'package:driveforme_user/src/data/constants/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primaryBlue,
      onPrimary: AppColors.onPrimaryText,
      primaryContainer: AppColors.primaryBlueLight,
      onPrimaryContainer: AppColors.onPrimaryText,
      secondary: AppColors.accentGold,
      onSecondary: AppColors.primaryText,
      surface: AppColors.cardBackground,
      onSurface: AppColors.primaryText,
      onSurfaceVariant: AppColors.secondaryText,
      outline: AppColors.cardBorder,
      error: AppColors.errorRed,
      onError: AppColors.onPrimaryText,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: router.generateRoute,
      initialRoute: 'Splash',
      title: 'Drive For Me',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.scaffoldBackground,
        colorScheme: colorScheme,
        fontFamily: 'ClashGrotesk',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
          displayMedium: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
          displaySmall: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
          titleLarge: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
          titleMedium: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
          titleSmall: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w400,
            color: AppColors.primaryText,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w400,
            color: AppColors.primaryText,
          ),
          bodySmall: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryText,
          ),
          labelLarge: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w400,
            color: AppColors.primaryText,
          ),
          labelMedium: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryText,
          ),
          labelSmall: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w400,
            color: AppColors.secondaryText,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.primaryText,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'ClashGrotesk',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: AppColors.primaryText,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.divider,
          thickness: 1,
        ),
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.navigationBackground,
          selectedItemColor: AppColors.navigationActive,
          unselectedItemColor: AppColors.navigationInactive,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.white
                : AppColors.white,
          ),
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.primaryBlue
                : AppColors.greyLight,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.onPrimaryText,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryBlue,
            side: const BorderSide(color: AppColors.cardBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputBackground,
          hintStyle: TextStyle(color: AppColors.disabledText),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.errorRed, width: 1.5),
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
