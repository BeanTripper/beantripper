import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bean_tripper/presentation/pages/feeds/feeds_page_viewmodel.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:bean_tripper/presentation/pages/feeds/comment_dialog.dart';
import 'package:bean_tripper/presentation/pages/feed_write/feed_write_page.dart';
import 'package:bean_tripper/presentation/pages/map/map_page.dart';

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
        title: Image.asset(
          'assets/images/login_logo.png',
          height: 35,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapPage()), // 맵 페이지로 이동
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage()), // 프로필 페이지로 이동
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
          Container(
            height: 120, // 가로 스크롤 이미지를 위한 높이 설정
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5, // 예시 이미지 수 설정
              separatorBuilder: (context, index) =>
                  SizedBox(width: 8), // 이미지들 사이 간격 설정
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  color: Colors.transparent,
                  child: Image.asset('assets/images/cafe${index + 1}.jpg',
                      fit: BoxFit.cover),
                );
              },
            ),
          ),
          Expanded(
            child: feedState.when(
              data: (posts) => ListView.builder(
                controller: _scrollController,
                itemCount: posts.length, // 게시물 수 설정
                itemBuilder: (context, index) {
                  final post = posts[index]; // 각 게시물 가져오기
                  return PostWidget(post: post); // PostWidget으로 게시물 표시
                },
              ),
              loading: () =>
                  Center(child: CircularProgressIndicator()), // 로딩 중일 때 표시할 위젯
              error: (error, stack) =>
                  Center(child: Text('Error: $error')), // 에러 발생 시 표시할 위젯
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FeedWritePage()), // WritePage로 이동
          );
        },
        child: Icon(Icons.edit), // 연필 모양 아이콘
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)), // 네모 모양
        ),
        backgroundColor: Color(0xFFA47764), // 버튼 색상 설정
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final Feed post; // 게시물 데이터를 담고 있는 Feed 객체

  PostWidget({required this.post}); // 생성자 정의 및 required로 post 매개변수 필수 설정

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(post.imageUrl), // 게시물 이미지 URL을 통해 이미지를 표시
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () {
                  // 좋아요 버튼 로직 추가
                },
              ),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {
                  showCommentDialog(context, post); // 댓글 창 표시
                },
              ),
            ],
          ),
          Text(post.description),
        ],
      ),
    );
  }
}
