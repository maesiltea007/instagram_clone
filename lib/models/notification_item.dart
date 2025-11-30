class NotificationItem {
  final String id;
  final String fromUserId;
  final String postId;
  final String text;
  final DateTime createdAt;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.fromUserId,
    required this.postId,
    required this.text,
    required this.createdAt,
    this.isRead = false,
  });
}