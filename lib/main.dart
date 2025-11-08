// lib/main.dart
import 'package:flutter/material.dart';
import 'package:sayarapp/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'screens/main_page.dart';
import 'screens/gunluk_hedefler_screen.dart';
import 'screens/dua_ve_zikirler_screen.dart';
import 'screens/zikir_screen.dart';
import 'screens/yeni_zikir_screen.dart';
import 'screens/esma_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Eski database'i kontrol edip taşı
  await DatabaseHelper.instance.migrateOldDatabase();
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool gece = prefs.getBool('geceModu') ?? false;
  final ThemeMode initialMode = gece ? ThemeMode.dark : ThemeMode.light;

  runApp(AppRoot(initialTheme: initialMode));
}

class ThemeController extends ChangeNotifier {
  ThemeMode _mode;
  ThemeController(this._mode);
  ThemeMode get mode => _mode;
  void setMode(ThemeMode m) {
    if (_mode == m) return;
    _mode = m;
    notifyListeners();
  }
}

class AppRoot extends StatefulWidget {
  final ThemeMode initialTheme;
  const AppRoot({super.key, required this.initialTheme});
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late final ThemeController themeController;

  @override
  void initState() {
    super.initState();
    themeController = ThemeController(widget.initialTheme);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sayar',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.mode,
          initialRoute: '/main',
          routes: {
            '/main': (_) => const MainPage(),
            '/gunluk': (_) => const GunlukHedeflerScreen(),
            '/duavezikir': (_) => const DuaVeZikirlerScreen(),
            '/yeni_zikir': (_) => const YeniZikirScreen(),
            '/esma': (_) => const EsmaScreen(),
            '/ayarlar': (_) => SettingsScreen(controller: themeController),
            '/zikirmatik': (context) => ZikirScreen(),
          },
        );
      },
    );
  }
}
