import 'package:bean_tripper/data/data_source/app_user_data_source_impl.dart';
import 'package:bean_tripper/data/data_source/cafe_data_source.dart';
import 'package:bean_tripper/data/data_source/cafe_data_source_impl.dart';
import 'package:bean_tripper/data/repository/app_user_repository_impl.dart';
import 'package:bean_tripper/data/repository/cafe_repository_impl.dart';
import 'package:bean_tripper/domain/repository/app_user_repository.dart';
import 'package:bean_tripper/domain/repository/cafe_repository.dart';
import 'package:bean_tripper/domain/usecase/fetch_cafe_item_usecase.dart';
import 'package:bean_tripper/domain/usecase/fetch_cafes_list_usecase.dart';
import 'package:bean_tripper/domain/usecase/fetch_user_usecase.dart';
import 'package:bean_tripper/domain/usecase/save_user_usecase.dart';
import 'package:bean_tripper/domain/usecase/update_user_usecase.dart';
import 'package:bean_tripper/presentation/pages/feed_write/feed_wirte_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _appUserRepository = Provider<AppUserRepository>((ref) {
  return AppUserRepositoryImpl(
      AppUserDataSourceImpl(FirebaseFirestore.instance));
});

final fetchUserUseCaseProvider = Provider<FetchUserUseCase>((ref) {
  return FetchUserUseCase(ref.read(_appUserRepository));
});

final saveUserUseCaseProvider = Provider<SaveUserUseCase>((ref) {
  return SaveUserUseCase(ref.read(_appUserRepository));
});

final updateUserUseCaseProvider = Provider<UpdateUserUseCase>((ref) {
  return UpdateUserUseCase(ref.read(_appUserRepository));
});

final feedWriteViewModelProvider = ChangeNotifierProvider((ref) {
  return FeedWriteViewModel();
});

// 카페
final _cafeDataSource = Provider<CafeDataSource>((ref) {
  return CafeDataSourceImpl();
});

final _cafeRepository = Provider<CafeRepository>((ref) {
  final dataSource = ref.read(_cafeDataSource);
  return CafeRepositoryImpl(dataSource);
});

final fetchCafesListUsecaseProvider = Provider((ref) {
  final cafeRefo = ref.read(_cafeRepository);
  return FetchCafesListUsecase(cafeRefo);
});

final fetchCafeItemUsecaseProvider = Provider((ref) {
  final cafeRefo = ref.read(_cafeRepository);
  return FetchCafeItemUsecase(cafeRefo);
});
