import 'package:bean_tripper/firebase_options.dart';
import 'package:bean_tripper/presentation/pages/feeds/feeds_page.dart';
import 'package:bean_tripper/presentation/pages/login/login_page.dart';
import 'package:bean_tripper/presentation/pages/feed_write/feed_write_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    name: 'bean_tripper',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Pretendard',
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}
