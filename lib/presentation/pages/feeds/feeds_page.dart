import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bean_tripper/domain/entity/feed.dart';
import 'package:bean_tripper/presentation/pages/feeds/comment_dialog.dart';
import 'package:bean_tripper/presentation/pages/feed_write/feed_write_page.dart';
import 'package:bean_tripper/presentation/pages/map/map_page.dart';
import 'package:bean_tripper/core/widgets/feed_content.dart';
import 'package:bean_tripper/core/widgets/feed_info.dart';
import 'package:bean_tripper/presentation/pages/profile/profile_page.dart'; // 프로필 페이지 import 추가

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
      // 추가 피드 데이터 로드 로직
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // 여기서 map_page로 이동합니다.
              Navigator.pushNamed(context, '/map_page');
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // 여기서 프로필 페이지로 이동합니다.
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfilePage()), // 예시로 userId 설정
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
                fontSize:
                    Theme.of(context).textTheme.headlineLarge!.fontSize! * 0.6,
              ),
            ),
          ),
          Container(
            height: 120, // 가로 스크롤 이미지를 위한 높이 설정
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('cafes').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var documents = snapshot.data!.docs;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: documents.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 8), // 이미지들 사이 간격 설정
                  itemBuilder: (context, index) {
                    var data = documents[index].data() as Map<String, dynamic>;
                    return Container(
                      width: 100,
                      color: Colors.transparent,
                      child: Image.network(data['imageUrl'], fit: BoxFit.cover),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('feeds').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var posts = snapshot.data!.docs
                    .map((doc) => Feed.fromFirestore(doc))
                    .toList();
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: posts.length, // 게시물 수 설정
                  itemBuilder: (context, index) {
                    final post = posts[index]; // 각 게시물 가져오기
                    return Column(
                      children: [
                        FeedInfo(),
                        FeedContent(),
                        GestureDetector(
                          onTap: () {
                            showCommentDialog(context, post); // 댓글 창 표시
                          },
                          child: Icon(Icons.chat_bubble_outline, size: 30),
                        ),
                      ],
                    );
                  },
                );
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
