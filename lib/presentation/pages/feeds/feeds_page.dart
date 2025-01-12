import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/presentation/pages/feeds/trending_cafe_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/presentation/pages/profile/profile_page.dart';
import 'package:bean_tripper/presentation/pages/feeds/cafe_of_the_day.dart';
import 'package:bean_tripper/core/widgets/feed_content.dart';
import 'package:bean_tripper/core/widgets/feed_info.dart';
import 'package:bean_tripper/presentation/pages/feeds/feeds_page_viewmodel.dart';

class FeedsPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<FeedsPage> createState() => _FeedsPageState();
}

class _FeedsPageState extends ConsumerState<FeedsPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _refreshData(feedProvider);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData(feedProvider);
  }

  Future<void> _refreshData(dynamic feedsPageViewModelProvider) async {
    // 오늘의 카페 데이터 새로고침
    await ref.read(trendingCafeViewModelProvider.notifier).refresh();
    // 피드 데이터 새로고침
    await ref.read(feedsPageViewModelProvider.notifier).refresh();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      ref.read(feedProvider.notifier).fetchMoreFeeds(); // 추가 피드 데이터 로드
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final feedState = ref.watch(feedProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/login_logo.png',
          height: 35,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.pushNamed(context, '/map_page'); // 여기서 map_page로 이동
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage()), // 여기서 프로필 페이지로 이동
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '오늘의 카페',
                style: TextStyle(
                  color: CustomColors.brown, // 글씨 색상 설정
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // Theme.of(context).textTheme.headlineLarge!.fontSize! *
                  // 0.6, // 글씨 크기 절반으로 설정
                ),
              ),
            ),
            const SizedBox(height: 3),
            CafeOfTheDay(), // "오늘의 카페" 부분
            feedState.when(
              data: (feeds) {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: feeds.length,
                  itemBuilder: (context, index) {
                    final feed = feeds[index];
                    return Column(
                      children: [
                        FeedInfo(feed: feed), // FeedInfo 위젯 사용
                        FeedContent(feed: feed), // FeedContent 위젯 사용
                      ],
                    );
                  },
                );
              },
              loading: () {
                return Center(child: CircularProgressIndicator());
              },
              error: (e, stackTrace) {
                return Center(child: Text('Error: $e'));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cafe_selection_page');
        },
        child: Icon(Icons.edit),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        backgroundColor: Color(0xFFA47764),
      ),
    );
  }
}
