// Ported from FlowSpace
class ChannelSummary {
  const ChannelSummary({
    required this.id,
    required this.name,
    this.description,
    this.updatedAt,
    this.lastMessage,
  });

  final String id;
  final String name;
  final String? description;
  final DateTime? updatedAt;
  final ChannelLastMessage? lastMessage;
}

class ChannelLastMessage {
  const ChannelLastMessage({
    required this.id,
    required this.senderId,
    this.senderName,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String senderId;
  final String? senderName;
  final String content;
  final DateTime createdAt;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.channelId,
    required this.senderId,
    this.senderName,
    required this.content,
    required this.createdAt,
    this.attachments = const [],
    this.reactions,
  });

  final String id;
  final String channelId;
  final String senderId;
  final String? senderName;
  final String content;
  final DateTime createdAt;
  final List<String> attachments; // Simplified for MVP
  final Map<String, List<String>>? reactions; // emoji -> list of userIds
}
