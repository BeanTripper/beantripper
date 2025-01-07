// import 'package:bean_tripper/data/data_source/cafe_data_source_impl.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// class MockAssetBundle extends Mock implements AssetBundle {}

// void main() {
//   late final MockAssetBundle mockAssetBundle;
//   late final CafeDataSourceImpl cafeDataSourceImpl;
//   setUp(
//     () async {
//       mockAssetBundle = MockAssetBundle();
//       cafeDataSourceImpl = CafeDataSourceImpl(mockAssetBundle);
//     },
//   );

//   test(
//     'MockDataTest',
//     () async {
//       // 가짜데이터 주입
//       when(() => mockAssetBundle.loadString(any())).thenAnswer((_) async => """
//   [{
//       "id": "123",
//       "name": "가게 이름",
//       "address": "카페 주소 동동동",
//       "operatingTime": "아침저녁",
//       "tel": "010-1234-2456"
//   }]
// """);

//       // 호출
//       final result = await cafeDataSourceImpl.fetchCafesList();
//       // 검증
//       expect(result?.length, 1);
//     },
//   );
// }
