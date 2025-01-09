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
            // 화면 클릭 시 키보드 닫기
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
            '⚠ 프랜차이즈 커피 매장은 검색에서 제외됩니다.',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
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
            width: double.infinity, // 버튼 양옆으로 꽉 채움
            child: ElevatedButton(
              onPressed: () {
                if (viewModel.selectedCafe != null) {
                  Navigator.pushNamed(
                    context,
                    '/feedwritepage',
                    arguments: viewModel.selectedCafe!['name'],
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('카페를 선택해주세요.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA47764),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                '카페 입력',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
