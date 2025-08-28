import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'login_screen.dart';
import 'models/pet_profile.dart';
import 'models/main_bottom_nav.dart';
import 'models/pet_profile_provider.dart';


PetProfile? lastSelectedProfile; // 전역변수 (마지막 본 프로필 저장)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mljwvknbhwgtcbwbmimh.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1sand2a25iaHdndGNid2JtaW1oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUzNTc2MTksImV4cCI6MjA3MDkzMzYxOX0.IfnELTNHeJZXkmn5BWA_aY_lxK2m7J87Ew-mSjC1wE8',
  );

  await initializeDateFormatting('ko_KR', null);

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
          ? const MainBottomNav()
          : LoginScreen(onLoginSuccess: _onLoginSuccess),
    );
  }
}