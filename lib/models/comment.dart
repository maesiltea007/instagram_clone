class Comment {
  final String id;
  final String postid;
  final String authorId;
  final String text;
  final DateTime createdAt;
  int likeCount;

  Comment({
    required this.id,
    required this.postid,
    required this.authorId,
    required this.text,
    required this.createdAt,
    this.likeCount = 0,
  });
}