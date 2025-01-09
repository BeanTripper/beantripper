import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/presentation/pages/feeds/comment_dialog.dart';
import 'package:bean_tripper/presentation/pages/profile/profile_page.dart';
import 'package:bean_tripper/presentation/pages/feeds/cafe_of_the_day.dart';
import 'package:bean_tripper/core/widgets/feed_content.dart';
import 'package:bean_tripper/core/widgets/feed_info.dart';
import 'package:bean_tripper/constant/theme.dart';
import 'package:bean_tripper/presentation/pages/feeds/feeds_page_viewmodel.dart';

class FeedsPage extends ConsumerStatefulWidget {
  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends ConsumerState<FeedsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Text(
              '오늘의 카페',
              style: TextStyle(
                color: Color(0xFFA47764), // 글씨 색상 설정
                fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize! *
                    0.6, // 글씨 크기 절반으로 설정
              ),
            ),
          ),
          CafeOfTheDay(), // "오늘의 카페" 부분
          Expanded(
            child: feedState.when(
              data: (feeds) {
                print("피드 데이터 불러오기 성공: ${feeds.length}개"); // 데이터 로드 성공 여부 확인
                feeds.forEach((feed) {
                  print(
                      "카페 이름: ${feed.cafeName}, 작성자: ${feed.writerName}"); // 각 피드 데이터 확인
                });
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: feeds.length,
                  itemBuilder: (context, index) {
                    final feed = feeds[index];
                    return Column(
                      children: [
                        FeedInfo(feed: feed), // FeedInfo 위젯 사용
                        FeedContent(feed: feed), // FeedContent 위젯 사용
                        GestureDetector(
                          onTap: () {
                            showCommentDialog(context, feed); // 댓글 창 표시
                          },
                          child: Icon(Icons.chat_bubble_outline, size: 30),
                        ),
                        Text(feed.cafeName), // 테스트를 위해 카페 이름을 추가
                      ],
                    );
                  },
                );
              },
              loading: () {
                print("데이터 로딩 중...");
                return Center(child: CircularProgressIndicator());
              },
              error: (e, stackTrace) {
                print("데이터 불러오기 오류: $e");
                return Center(child: Text('Error: $e'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/feeds_write_page');
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
