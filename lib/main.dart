import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:makosso_app/model/user.dart';
import 'package:makosso_app/screen/autentification_screen.dart';
import 'package:makosso_app/screen/screen_element.dart/audio_screen.dart';
import 'package:makosso_app/screen/screen_element.dart/video_screen.dart';
import 'package:makosso_app/screen/tab/bottom_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'api/fil_actualite/fil_actualitte.dart';
import 'provider/auth_provider.dart';

final flutterSecureStorage = FlutterSecureStorage();

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref);
});
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final service = FilActualitService();
    await service.recupererfilactualite(isFeeded: inputData?['isFeeded'] ?? 1);

    return Future.value(true);
  });
}

void scheduleBackgroundSync() {
  Workmanager().registerPeriodicTask(
    "sync_fil_actualite",
    "sync_fil_actualite_task",
    inputData: {'isFeeded': 1},
    frequency: const Duration(hours: 1),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;

  if (!hasSeenIntro) {
    prefs.setBool('hasSeenIntro', true);
  }
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );
  scheduleBackgroundSync(); // Planification des tâches périodiques
  final storedToken = await flutterSecureStorage.read(key: 'auth_token');

  runApp(
    ProviderScope(
      child: MyApp(
        storedToken: storedToken,
        hasSeenIntro: hasSeenIntro,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? storedToken;
  final bool hasSeenIntro;

  const MyApp(
      {super.key, required this.storedToken, required this.hasSeenIntro});

  @override
  Widget build(BuildContext context) {
    // Récupérer la largeur de l'écran
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculer le facteur de mise à l'échelle
    double scaleFactor = screenWidth /
        375; // 375 est la largeur de base pour un design moyen (par exemple iPhone 7)

    // Définir les tailles de police de base
    double baseTitleSmall = 12;
    double baseTitleMedium = 14;
    double baseTitleLarge = 16;
    double basedisplay = 14;

    // Appliquer l'échelle tout en garantissant une taille minimale
    double titleSmallFontSize = baseTitleSmall * scaleFactor;
    double titleMediumFontSize = baseTitleMedium * scaleFactor;
    double titlelargeFontSize = baseTitleLarge * scaleFactor;
    double displayFontSize = basedisplay * scaleFactor;

    // Assurez-vous que la taille ne devienne pas trop petite
    titleSmallFontSize = titleSmallFontSize < baseTitleSmall
        ? baseTitleSmall
        : titleSmallFontSize;
    titleMediumFontSize = titleMediumFontSize < baseTitleMedium
        ? baseTitleMedium
        : titleMediumFontSize;

    titlelargeFontSize = titlelargeFontSize < baseTitleLarge
        ? baseTitleLarge
        : titlelargeFontSize;

    displayFontSize =
        displayFontSize < basedisplay ? basedisplay : displayFontSize;

    return MaterialApp(
      title: 'Makosso',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.white,
        // tabBarTheme: const TabBarTheme(
        //   labelColor: Color.fromARGB(255, 255, 255, 255),
        //   unselectedLabelColor: Color.fromARGB(255, 70, 70, 70),
        //   indicatorColor: Colors.white,
        // ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          foregroundColor: const Color.fromARGB(255, 54, 136, 57),
        ),
        textTheme: TextTheme(
          titleSmall: TextStyle(
            fontSize: titleSmallFontSize, // Taille responsive pour titleSmall
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 134, 134, 134),
          ),
          titleMedium: TextStyle(
            fontSize: baseTitleMedium, // Taille responsive pour titleMedium
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            fontSize: titleMediumFontSize, // Taille responsive pour titleMedium
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          bodyMedium: TextStyle(
            fontSize: titleMediumFontSize, // Taille responsive pour titleMedium
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          bodySmall: TextStyle(
            color: const Color.fromARGB(255, 90, 90, 90),
            fontSize: titleMediumFontSize,
            fontWeight: FontWeight.w400,
          ),
          labelMedium: TextStyle(
            fontSize: titleMediumFontSize,
            color: const Color.fromARGB(255, 130, 130, 130),
          ),
          labelLarge: TextStyle(
            fontSize: titlelargeFontSize,
            color: const Color.fromARGB(255, 120, 120, 120),
          ),
          displaySmall: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: displayFontSize,
            color: const Color.fromARGB(255, 109, 109, 109),
          ),
          displayMedium: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: displayFontSize,
            color: const Color.fromARGB(255, 0, 129, 17),
          ),
        ),
      ),
      initialRoute: storedToken != null && storedToken!.isNotEmpty
          ? 'Home'
          : 'authScreen',
      routes: {
        'authScreen': (ctx) => AuthenticationScreen(),
        'Home': (ctx) => const BottomNavbar(),
        'audioScreen': (ctx) => const AudioScreen(),
        'videoScreen': (ctx) => VideoScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
