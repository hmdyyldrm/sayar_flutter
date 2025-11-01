import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ekranların importları
import 'screens/main_page.dart';
import 'screens/gunluk_hedefler_screen.dart';
import 'screens/esma_screen.dart';
import 'screens/edit_goal_screen.dart';
import 'screens/auth_screens.dart';
import 'screens/dua_ve_zikir_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // varsa ilk ayar yüklemeleri (ör. SharedPreferences okuma)
  final prefs = await SharedPreferences.getInstance();
  final hasPassword = prefs.getString('password')?.isNotEmpty ?? false;

  runApp(MyApp(hasPassword: hasPassword));
}

class MyApp extends StatelessWidget {
  final bool hasPassword;
  const MyApp({super.key, required this.hasPassword});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zikir Uygulaması',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      

      // eğer kullanıcıda şifre varsa giriş ekranı, yoksa ana sayfa
      initialRoute: hasPassword ? '/auth' : '/main',

      routes: {
        '/auth': (_) => const GirisScreen(),
        '/main': (_) => const MainPage(),
        '/gunluk': (_) => const GunlukHedeflerScreen(),
        '/esma': (_) => const EsmaScreen(),
        '/dua': (_) => const DuaVeZikirScreen(),
        '/ayarlar': (_) => const DuaVeZikirScreen(),
        '/zikirmatik': (_) => const HomeScreen(isDarkMode: false),
        '/edit': (_) => const EditGoalScreen(index: 0, metin: '', hedef: 0, sayac: 0),
        
      },
    );
  }
}
