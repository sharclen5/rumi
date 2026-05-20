import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rumi/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rumi/services/auth.dart';
import 'firebase_options.dart';
import 'package:rumi/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ required before Firebase.initializeApp
  await Firebase.initializeApp(
    // ✅ initialize Firebase first
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(home: Wrapper()),
    );
  }
}
