import 'package:bean_tripper/domain/entity/cafe.dart';
import 'package:bean_tripper/domain/entity/user.dart';

class Feed {
  int id;
  String content;
  Cafe cafe;
  User writer;

  Feed({
    required this.id,
    required this.content,
    required this.cafe,
    required this.writer,
  });
}
