import 'package:bean_tripper/presentation/view_model/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer(builder: (context, ref, child) {
          final profileState = ref.read(authViewModelProvider);

          return Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  child: profileState.appUser?.profile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                              profileState.appUser?.profile ?? ''))
                      : Icon(Icons.person, size: 50),
                ),
                SizedBox(height: 16),
                Text(
                  profileState.appUser?.name ?? '사용자',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  FirebaseAuth.instance.currentUser?.email ??
                      'example@naver.com',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushNamed(context, '/login_page');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('로그아웃'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
