import 'package:bean_tripper/domain/entity/user.dart';

class CommentDto {
  int id;
  String comment;
  User writer;

  CommentDto({
    required this.id,
    required this.comment,
    required this.writer,
  });
}
