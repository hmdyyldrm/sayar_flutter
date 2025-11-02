import 'package:flutter/material.dart';
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
  final prefs = await SharedPreferences.getInstance();
  final hasPassword = (prefs.getString('password') ?? '').isNotEmpty;

  runApp(MyApp(initialRoute: hasPassword ? '/auth' : '/main'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sayar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: initialRoute,
      routes: {
        '/main': (_) => const MainPage(),
        '/zikirmatik': (context) => const ZikirScreen(),
        '/gunluk': (_) => const GunlukHedeflerScreen(),
        '/duavezikir': (_) => const DuaVeZikirlerScreen(),
        // zikir detail uses MaterialPageRoute with args
        '/yeni_zikir': (_) => const YeniZikirScreen(),
        '/esma': (_) => const EsmaScreen(),
        '/ayarlar': (_) => const SettingsScreen(),
      },
      // If auth route exists, you can add '/auth' mapping to your auth screen
    );
  }
}
