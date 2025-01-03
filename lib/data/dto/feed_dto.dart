import 'package:bean_tripper/domain/entity/cafe.dart';
import 'package:bean_tripper/domain/entity/user.dart';

class FeedDto {
  int id;
  String content;
  Cafe cafe;
  User writer;

  FeedDto({
    required this.id,
    required this.content,
    required this.cafe,
    required this.writer,
  });
}
