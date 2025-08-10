import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: true, // 디버그 배너 제거(false)
      home: Scaffold(
        body: Center(
          child: Text(
            "Hello World",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
