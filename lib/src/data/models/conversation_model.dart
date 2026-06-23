class ConversationModel {
  final String otherUserId;
  final String otherUserName;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ConversationModel({
    required this.otherUserId,
    this.otherUserName = '',
    this.lastMessage = '',
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final otherUser = json['otherUser'] ?? json['participant'];
    final otherMap = otherUser is Map
        ? Map<String, dynamic>.from(otherUser)
        : null;
    final lastMsg = json['lastMessage'];
    final lastMap =
        lastMsg is Map ? Map<String, dynamic>.from(lastMsg) : null;

    return ConversationModel(
      otherUserId: _userId(otherMap) ??
          json['otherUserId']?.toString() ??
          '',
      otherUserName: _userName(otherMap) ??
          json['otherUserName']?.toString() ??
          'User',
      lastMessage: lastMap?['content']?.toString() ??
          json['lastMessageText']?.toString() ??
          '',
      lastMessageAt: ChatMessageModelParse.parseDate(
        lastMap?['createdAt'] ?? json['updatedAt'],
      ),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
    );
  }

  static String? _userId(Map<String, dynamic>? user) {
    if (user == null) return null;
    final id = user['_id'] ?? user['id'] ?? user['userId'];
    return id?.toString();
  }

  static String? _userName(Map<String, dynamic>? user) {
    if (user == null) return null;
    final profile = user['profile'];
    if (profile is Map && profile['fullName'] != null) {
      final name = profile['fullName'].toString().trim();
      if (name.isNotEmpty) return name;
    }
    return user['fullName']?.toString();
  }
}

/// Shared date parsing for conversation + message models.
class ChatMessageModelParse {
  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}
