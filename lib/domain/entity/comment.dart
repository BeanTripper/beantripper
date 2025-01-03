import 'package:bean_tripper/domain/entity/user.dart';

class Comment {
  int id;
  String comment;
  User writer;

  Comment({
    required this.id,
    required this.comment,
    required this.writer,
  });
}
