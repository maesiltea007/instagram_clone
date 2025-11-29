class Comment {
  final String id;
  final String postid;
  final String authorId;
  final String text;
  final DateTime createdAt;
  bool like;

  Comment({
    required this.id,
    required this.postid,
    required this.authorId,
    required this.text,
    required this.createdAt,
    this.like = false,
  });
}