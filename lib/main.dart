import 'package:evminute/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:evminute/screens/sign_in/sign_in_screen.dart';
import 'routes.dart';
import 'theme.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
  requestPermissions();
}

Future<void> requestPermissions() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    // Location permission is granted
  } else {
    // Handle denied or restricted permissions
  }

  status = await Permission.camera.request();
  if (status.isGranted) {
    // Camera permission is granted
  } else {
    // Handle denied or restricted permissions
  }

  status = await Permission.storage.request();
  if (status.isGranted) {
    // Storage permission is granted
  } else {
    // Handle denied or restricted permissions
  }
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
