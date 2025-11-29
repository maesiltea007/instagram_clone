class DmMessage {
  final String messageId;
  final String threadId;
  final String text;
  final DateTime createdAt;
  final bool isMine;

  DmMessage({
    required this.messageId,
    required this.threadId,
    required this.text,
    required this.createdAt,
    required this.isMine,
  });
}