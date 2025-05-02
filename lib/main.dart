import 'package:flutter/material.dart';
import 'features/authentication/presentation/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Group Organizer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(), // only showing UI for now
    );
  }
}
