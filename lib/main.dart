import 'dart:async';

import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/firebase_options.dart';
import 'package:bean_tripper/presentation/pages/cafe_detail/cafe_detail_page.dart';
import 'package:bean_tripper/presentation/pages/cafe_detail/cafe_feed_page.dart';
import 'package:bean_tripper/presentation/pages/cafe_selection/cafe_selection_page.dart';
import 'package:bean_tripper/presentation/pages/feed_write/feed_write_page.dart';
import 'package:bean_tripper/presentation/pages/feeds/feeds_page.dart';
import 'package:bean_tripper/presentation/pages/login/login_page.dart';
import 'package:bean_tripper/presentation/pages/login/register_page.dart';
import 'package:bean_tripper/presentation/pages/map/map_page.dart';
import 'package:bean_tripper/presentation/pages/splash/splash_page.dart';
import 'package:bean_tripper/presentation/pages/profile/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: ".env");

      await NaverMapSdk.instance.initialize(
        clientId: dotenv.get('NAVER_MAP_CLIENT_ID'),
        onAuthFailed: (ex) => print("********* 네이버맵 인증오류 : $ex *********"),
      );

      KakaoSdk.init(
        nativeAppKey: 'e9f3c287a2596309bf7be25870b4d726',
      );

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // 플러터 프레임워크 내부에서 발생하는 에러
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stack) {
      // Exception
      FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        fatal: true,
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/feeds_page': (context) => FeedsPage(),
        '/cafe_selection_page': (context) => CafeSelectionPage(),
        '/map_page': (context) => MapPage(),
        '/cafe_detail_page': (context) => CafeDetailPage(),
        '/login_page': (context) => LoginPage(),
        '/profile_page': (context) => ProfilePage(),
        '/register_page': (context) => RegisterPage(),
        '/cafe_feed_page': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
          final cafeId = arguments?['cafeId'] as String? ?? '';
          final selectedFeedId = arguments?['selectedFeedId'] as String? ?? '';
          return CafeFeedsPage(
            cafeId: cafeId,
            selectedFeedId: selectedFeedId,
          );
        },
        '/feedwritepage': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
          final selectedCafeName = arguments?['selectedCafeName'] ?? '카페 미선택';
          return FeedWritePage(selectedCafeName: selectedCafeName);
        }
      },
      // feeds_page로 가고 싶을때 pushNamed 사용예시:
      // ontap:(){Navigator.pushNamed(context, '/feeds_page')}
      theme: ThemeData(
        fontFamily: 'Pretendard',
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          backgroundColor: CustomColors.backgroundColor,
          scrolledUnderElevation: 0,
        ),
      ),

      home: SplashPage(),
      // home: RegisterPage(),
    );
  }
}
