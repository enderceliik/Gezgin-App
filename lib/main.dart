// @dart=2.9
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:yuruyus_app/auth/main_page.dart';
import 'package:yuruyus_app/providers/user_provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyDdN445roX64LroazOB1mhiTtAHNGkL_vA",
      appId: "1:889124039774:web:64b52799f76c5af8c558cf",
      messagingSenderId: "889124039774",
      projectId: "yuruyusapp-2b101",
      storageBucket: "yuruyusapp-2b101.appspot.com",
    ));
  }
  else
  {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}
