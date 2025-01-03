import 'package:bean_tripper/presentation/pages/feed_write/feed_write_page.dart';
import 'package:bean_tripper/presentation/pages/feeds/feeds_page.dart';
import 'package:bean_tripper/presentation/pages/home/home_view_model.dart';
import 'package:bean_tripper/presentation/pages/home/widgets/home_bottom_navigation_bar.dart';
import 'package:bean_tripper/presentation/pages/login/login_page.dart';
import 'package:bean_tripper/presentation/pages/map/map_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeViewModel);
    //print("지금 주소는!! ${state.address}");
    return Scaffold(
      body: IndexedStack(
        index: state,
        children: [
          FeedsPage(),
          FeedWritePage(),
          MapPage(),
          LoginPage(),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigationBar(),
    );
  }
}
