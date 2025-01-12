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
    Future.microtask(() => _refreshData());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() => _refreshData());
  }

  Future<void> _refreshData() async {
    try {
      // 두 데이터를 병렬로 새로고침
      await Future.wait([
        ref.read(trendingCafeViewModelProvider.notifier).refresh(),
        ref.read(feedProvider.notifier).refresh(),
      ]);
    } catch (e) {
      print('Error refreshing data: $e');
    }
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
      ref.read(feedProvider.notifier).fetchMoreFeeds();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final feedState = ref.watch(feedProvider);
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            title: Image.asset(
              'assets/images/login_logo.png',
              height: 35,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.map, color: CustomColors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/map_page');
                },
              ),
              IconButton(
                icon: Icon(Icons.person, color: CustomColors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
            ],
          ),
        ],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  '오늘의 카페',
                  style: TextStyle(
                    color: CustomColors.brown,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CafeOfTheDay(),
              Transform.translate(
                offset: Offset(0, -20),
                child: feedState.when(
                  data: (feeds) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: feeds.length,
                      itemBuilder: (context, index) {
                        final feed = feeds[index];
                        return Column(
                          children: [
                            FeedInfo(feed: feed),
                            FeedContent(feed: feed),
                            SizedBox(height: 18),
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cafe_selection_page');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        backgroundColor: Color(0xFFA47764),
        child: Icon(Icons.edit),
      ),
    );
  }
}
