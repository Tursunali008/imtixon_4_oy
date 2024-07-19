import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:imtixon_4_oy/services/tadbir_service.dart';
import 'package:provider/provider.dart';
import 'package:imtixon_4_oy/controller/auth_controller.dart';
import 'package:imtixon_4_oy/firebase_options.dart';
import 'package:imtixon_4_oy/view/screen/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale("uz"),
        Locale("en"),
      ],
      path: "resources/langs",
      startLocale: const Locale("uz"),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthController()),
        ChangeNotifierProvider(create: (context) => EventService()),
      ],
      child: AdaptiveTheme(
        initial: AdaptiveThemeMode.light,
        light: ThemeData(brightness: Brightness.light),
        dark: ThemeData(brightness: Brightness.dark),
        builder: (lightTheme, darkTheme) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
