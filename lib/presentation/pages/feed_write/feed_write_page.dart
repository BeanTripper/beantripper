import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bean_tripper/presentation/pages/feed_write/widgets/image_picker_section.dart';
import 'package:bean_tripper/presentation/pages/feed_write/widgets/text_input_section.dart';
import 'package:bean_tripper/presentation/pages/feed_write/widgets/tag_selection_section.dart';
import 'package:bean_tripper/presentation/pages/feed_write/widgets/submit_button.dart';
import 'package:bean_tripper/presentation/provider.dart';

class FeedWritePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(feedWriteViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('작성하기'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
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
                const Text(
                  '태그',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var tag in ['커피맛집', '모던한', '디자인이 예쁜', '따뜻한', '깔끔한', '다시 방문하고 싶은'])
                      GestureDetector(
                        onTap: () {
                          viewModel.toggleTagSelection(tag);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: viewModel.categories.contains(tag) ? const Color(0xFFA47764) : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              color: viewModel.categories.contains(tag) ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await viewModel.uploadDataToFirebase();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('업로드 성공!')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('업로드 실패: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA47764),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      '작성 완료',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
