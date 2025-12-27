import 'package:supabase_flutter/supabase_flutter.dart';

class ChatMessage {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String messageText;
  final DateTime? timestamp;
  final bool isSeen;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.messageText,
    this.timestamp,
    required this.isSeen,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      messageId: json['messageID']?.toString() ?? json['messageId']?.toString() ?? '',
      senderId: json['senderID']?.toString() ?? json['senderId']?.toString() ?? '',
      receiverId: json['receiverID']?.toString() ?? json['receiverId']?.toString() ?? '',
      messageText: json['messageText']?.toString() ?? '',
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp']) : null,
      isSeen: json['isSeen'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageID': messageId,
      'senderID': senderId,
      'receiverID': receiverId,
      'messageText': messageText,
      'timestamp': timestamp?.toIso8601String(),
      'isSeen': isSeen,
    };
  }

  static final _supabase = Supabase.instance.client;

  static Future<List<ChatMessage>> fetchMessages(String senderId, String receiverId) async {
    try {
      final response = await _supabase
          .from('messages')
          .select()
          .or('and(senderID.eq.$senderId,receiverID.eq.$receiverId),and(senderID.eq.$receiverId,receiverID.eq.$senderId)')
          .order('timestamp', ascending: true);
      return (response as List).map((json) => ChatMessage.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  static Future<void> sendMessage(ChatMessage message) async {
    try {
      await _supabase.from('messages').insert(message.toJson());
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }
}
