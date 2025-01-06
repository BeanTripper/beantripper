class Comment {
  String id;
  String comment;
<<<<<<< HEAD
  String writerId;
  String writerName;
=======
  AppUser writer;
>>>>>>> 8b6ed5e (fix: User->AppUser로 변경(googleLogin 클래스와 겹침))

  Comment({
    required this.id,
    required this.comment,
    required this.writerId,
    required this.writerName,
  });
}
