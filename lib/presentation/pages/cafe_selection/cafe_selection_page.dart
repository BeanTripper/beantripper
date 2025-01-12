import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cafe_selection_viewmodel.dart';

class CafeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CafeSelectionViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('카페 선택'),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: CafeSelectionBody(),
        ),
      ),
    );
  }
}

class CafeSelectionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CafeSelectionViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: '카페 이름을 입력하세요',
              border: OutlineInputBorder(),
            ),
            onChanged: (query) => viewModel.searchCafes(query),
          ),
          const SizedBox(height: 10),
          const Text(
            '프랜차이즈 커피 매장은 검색에서 제외됩니다.',
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.searchResults.isEmpty
                    ? const Center(child: Text('검색 결과가 없습니다.'))
                    : ListView.builder(
                        itemCount: viewModel.searchResults.length,
                        itemBuilder: (context, index) {
                          final cafe = viewModel.searchResults[index];
                          return ListTile(
                            title: Text(cafe['name']),
                            subtitle: Text(cafe['address'] ?? '주소 없음'),
                            onTap: () {
                              viewModel.setSelectedCafe(cafe);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${cafe['name']} 선택됨')),
                              );
                            },
                          );
                        },
                      ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: viewModel.selectedCafe == null
                  ? null
                  : () async {
                      final selectedCafe = viewModel.selectedCafe!;
                      try {
                        // Firebase 업로드
                        await viewModel.saveCafeToFirebase(selectedCafe);

                        // FeedWritePage로 이동
                        Navigator.pushReplacementNamed(
                          context,
                          '/feedwritepage',
                          arguments: {'selectedCafeName': selectedCafe['name']},
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Firebase 업로드 실패: $e')),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA47764),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                '카페 입력',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
