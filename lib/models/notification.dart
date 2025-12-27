import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationModel {
  final String notificationId;
  final String userId;
  final String? employerId;
  final String? title;
  final String message;
  final String? notificationType;
  final DateTime? createdAt;
  final bool isRead;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    this.employerId,
    this.title,
    required this.message,
    this.notificationType,
    this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationID']?.toString() ?? json['notificationId']?.toString() ?? '',
      userId: json['userID']?.toString() ?? json['userId']?.toString() ?? '',
      employerId: json['employerID']?.toString() ?? json['employerId']?.toString(),
      title: json['title']?.toString(),
      message: json['message']?.toString() ?? '',
      notificationType: json['notificationType']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationID': notificationId,
      'userID': userId,
      'employerID': employerId,
      'title': title,
      'message': message,
      'notificationType': notificationType,
      'createdAt': createdAt?.toIso8601String(),
      'isRead': isRead,
    };
  }

  static final _supabase = Supabase.instance.client;

  static Future<List<NotificationModel>> fetchNotifications(String userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select()
          .eq('userID', userId)
          .order('createdAt', ascending: false);
      return (response as List).map((json) => NotificationModel.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  static Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'isRead': true})
          .eq('notificationID', notificationId);
    } catch (e) {
      print('Error marking notification as read: $e');
      rethrow;
    }
  }

  static Future<void> createNotification(NotificationModel notification) async {
    try {
      await _supabase.from('notifications').insert(notification.toJson());
    } catch (e) {
      print('Error creating notification: $e');
      rethrow;
    }
  }
}
