//import 부분 수정 확인
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_page.dart';
import '../album_screen.dart';
import '../setting_screen.dart';
import '../calendar_screen.dart';
import 'pet_profile_provider.dart';

class MainBottomNav extends StatefulWidget {
  const MainBottomNav({super.key});

  @override
  State<MainBottomNav> createState() => _MainBottomNavState();
}

class _MainBottomNavState extends State<MainBottomNav> { //여기도 확인해보기
  int _selectedIndex = 0;
  DateTime? _lastTapTime;

  final List<Widget> _pages = const [
    HomePage(),
    Center(child: Text("리스트 페이지", style: TextStyle(fontSize: 24))),
    CalendarScreen(),
    AlbumScreen(),
    SettingScreen(),
  ];

  void _onItemTapped(int index) { //수정부분
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      DateTime now = DateTime.now();
      if (_lastTapTime != null && now.difference(_lastTapTime!) < const Duration(milliseconds: 400)) {
        // 더블탭: 프로필 선택 상태 초기화
        final provider = Provider.of<PetProfileProvider>(context, listen: false);
        provider.clearSelection();
      }
      _lastTapTime = now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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