import 'package:flutter/material.dart';
import 'package:evminute/screens/sign_in/sign_in_screen.dart';

import 'routes.dart';
import 'theme.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EVMinute',
      theme: AppTheme.lightTheme(context),
      initialRoute: SignInScreen.routeName,
      routes: routes,
    );
  }
}
