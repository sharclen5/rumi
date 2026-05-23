import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rumi/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rumi/services/auth.dart';
import 'firebase_options.dart';
import 'package:rumi/models/user.dart';

// $env:CHROME_EXECUTABLE="C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
// flutter run -d chrome
// pake ini buat jalanin di brave

// powertoys buat bikin tab brave stay on top
// win + ctrl + t

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
