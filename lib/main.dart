import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'album.dart';
import 'settingscreen.dart';
import 'home_page.dart';
import 'models/pet_profile.dart';


void main() {
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
  int _selectedIndex = 0;


  /// 페이지 목록
  List<Widget> _buildPages() {
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
    return MaterialApp(
      debugShowCheckedModeBanner: true, //디버깅 배너 표시
      home: Scaffold(
        body: _buildPages()[_selectedIndex],
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
