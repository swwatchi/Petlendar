import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'album_screen.dart';
import 'setting_screen.dart';
import 'home_page.dart';
import 'login_screen.dart';
import 'models/pet_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mljwvknbhwgtcbwbmimh.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sand2a25iaHdndGNid2JtaW1oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUzNTc2MTksImV4cCI6MjA3MDkzMzYxOX0.IfnELTNHeJZXkmn5BWA_aY_lxK2m7J87Ew-mSjC1wE8',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => PetProfileProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _checkingLogin = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final session = Supabase.instance.client.auth.currentSession;
    setState(() {
      _isLoggedIn = session != null;
      _checkingLogin = false;
    });
  }

  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingLogin) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: _isLoggedIn
          ? const MainScreen()
          : LoginScreen(onLoginSuccess: _onLoginSuccess),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Widget> _pages() {
    return [
      const HomePage(),
      const Center(child: Text("리스트 페이지", style: TextStyle(fontSize: 24))),
      const Center(child: Text("캘린더 페이지", style: TextStyle(fontSize: 24))),
      const AlbumScreen(),
      const SettingScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: '리스트'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '캘린더'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: '사진첩'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 44, 44, 44),
        unselectedItemColor: const Color.fromARGB(255, 129, 129, 129),
        onTap: _onItemTapped,
      ),
    );
  }
}

class PetProfileProvider extends ChangeNotifier {
  final List<PetProfile> _profiles = [];

  List<PetProfile> get profiles => _profiles;

  void addProfile(PetProfile profile) {
    _profiles.add(profile);
    notifyListeners();
  }

  void updateProfile(int index, PetProfile profile) {
    _profiles[index] = profile;
    notifyListeners();
  }
}
