import 'package:chat/services/http_service.dart';
import 'package:flutter/material.dart';

import 'screens/welcome/welcome_screen.dart';
import 'theme.dart';

void main() {
  HttpService().request("/v1/user/test", method: HTTP_METHOD.get);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Flutter Way',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.light,
      home: const WelcomeScreen(),
    );
  }
}
