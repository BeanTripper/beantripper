import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CafeOfTheDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // 가로 스크롤 이미지를 위한 높이 설정
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('cafes').snapshots(),
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
                height: 100,
                width: 100,
                color: Colors.yellowAccent,
                // child: Image.network(data['imageUrl'], fit: BoxFit.cover),
              );
            },
          );
        },
      ),
    );
  }
}
