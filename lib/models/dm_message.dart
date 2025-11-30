enum DmMessageType { text, image }

class DmMessage {
  final String messageId;
  final String threadId;
  final DmMessageType type;

  final String? text;
  final String? mediaPath;

  final DateTime createdAt;
  final bool isMine;

  const DmMessage({
    required this.messageId,
    required this.threadId,
    required this.type,
    this.text,
    this.mediaPath,
    required this.createdAt,
    required this.isMine,
  });
}