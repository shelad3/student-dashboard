class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String content;
  final String? attachmentUrl;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.content,
    this.attachmentUrl,
    required this.createdAt,
  });
}
