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

  FeedWritePage({required this.selectedCafeName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(feedWriteViewModelProvider);
    final userState = ref.watch(authViewModelProvider); // userState 가져오기

    // 선택된 카페 이름과 유저 정보 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((viewModel.cafeName?.isEmpty ?? true)) {
        viewModel.setCafeName(selectedCafeName); // 카페 이름 설정
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('작성하기'),
        centerTitle: true,
        leading: const SizedBox(), // 뒤로 가기 버튼 제거
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
                  userName: userState.appUser?.name ?? '익명', // 유저 이름 전달
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
