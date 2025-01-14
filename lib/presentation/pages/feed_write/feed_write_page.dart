import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/presentation/pages/feed_write/widgets/image_picker_section.dart';
import 'package:bean_tripper/presentation/pages/feed_write/widgets/text_input_section.dart';
import 'package:bean_tripper/presentation/pages/feed_write/widgets/tag_selection_section.dart';
import 'package:bean_tripper/presentation/pages/feed_write/widgets/submit_button.dart';
import 'package:bean_tripper/presentation/provider.dart';
import 'package:bean_tripper/presentation/view_model/auth_view_model.dart';

class FeedWritePage extends ConsumerWidget {
  final String selectedCafeName;

  const FeedWritePage({super.key, required this.selectedCafeName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(feedWriteViewModelProvider);
    final userState = ref.watch(authViewModelProvider); // userState 가져오기
    final userViewModel = ref.read(authViewModelProvider.notifier);
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null && args['selectedCafeName'] != null) {
      final selectedCafeName = args['selectedCafeName'];
      if (viewModel.cafeName != selectedCafeName) {
        viewModel.setCafeName(selectedCafeName); // 카페 이름 설정
      }
    }

    // 선택된 카페 이름과 유저 정보 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((viewModel.cafeName.isEmpty)) {
        viewModel.setCafeName(selectedCafeName); // 카페 이름 설정
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('작성하기'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // 뒤로가기 아이콘
          onPressed: () {
            // Navigator.popAndPushNamed로 새 페이지를 열고 기존 페이지를 스택에서 제거
            Navigator.pushReplacementNamed(context, '/cafe_selection_page');
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                ImagePickerSection(viewModel: viewModel),
                const SizedBox(height: 20),
                TextInputSection(viewModel: viewModel),
                const SizedBox(height: 20),
                TagSelectionSection(viewModel: viewModel),
                const SizedBox(height: 20),
                SubmitButton(
                  viewModel: viewModel,
                  // userName:userViewModel
                  //     .fetchUserName(userState.appUser!.id)
                  //     .toString(), // 유저 이름 전달
                  userName: userState.appUser?.id ?? '익명', // 유저 이름 전달
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
