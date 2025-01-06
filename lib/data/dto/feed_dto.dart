import 'package:bean_tripper/domain/entity/cafe.dart';

class FeedDto {
  String id;
  String content;
  String cafeId;
  String cafeName;
  String writerId;
  String writerName;

  FeedDto({
    required this.id,
    required this.content,
    required this.cafeId,
    required this.cafeName,
    required this.writerId,
    required this.writerName,
  });
}
