import 'package:bean_tripper/presentation/pages/feed_write/widgets/submit_button.dart';
import 'package:bean_tripper/presentation/pages/feed_write/widgets/tag_selection_section.dart';
import 'package:bean_tripper/presentation/pages/feed_write/widgets/text_input_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/presentation/pages/feed_write/widgets/image_picker_section.dart';
import 'package:bean_tripper/presentation/provider.dart';
import 'package:bean_tripper/presentation/view_model/auth_view_model.dart';

class FeedWritePage extends ConsumerWidget {
  final String selectedCafeName;

  const FeedWritePage({super.key, required this.selectedCafeName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(feedWriteViewModelProvider);
    final userState = ref.watch(authViewModelProvider);

    // 선택된 카페 이름 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.cafeName.isEmpty ||
          viewModel.cafeName != selectedCafeName) {
        viewModel.resetState(); // 상태 초기화
        viewModel.setCafeName(selectedCafeName); // 새로운 카페 이름 설정
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('작성하기'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            viewModel.resetState(); // 페이지 나갈 때 상태 초기화
            Navigator.pushReplacementNamed(context, '/cafe_selection_page');
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
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
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: SafeArea(
                child: SubmitButton(
                  viewModel: viewModel,
                  userName: userState.appUser?.name ?? '게스트',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
