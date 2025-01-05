import 'package:bean_tripper/domain/entity/cafe.dart';

class Feed {
  int id;
  String content;
  String cafeId;
  String cafeName;
  String writerId;
  String writerName;

  Feed({
    required this.id,
    required this.content,
    required this.cafeId,
    required this.cafeName,
    required this.writerId,
    required this.writerName,
  });
}
