import 'package:supabase_flutter/supabase_flutter.dart';

class TaskFeedback {
  final String feedbackId;
  final String taskId;
  final String employerId;
  final String employeeId;
  final String? feedbackText;
  final int? rating;
  final DateTime? submittedDate;
  final String? improvementNotes;
  final DateTime? createdAt;

  TaskFeedback({
    required this.feedbackId,
    required this.taskId,
    required this.employerId,
    required this.employeeId,
    this.feedbackText,
    this.rating,
    this.submittedDate,
    this.improvementNotes,
    this.createdAt,
  });

  factory TaskFeedback.fromJson(Map<String, dynamic> json) {
    return TaskFeedback(
      feedbackId: json['feedbackID']?.toString() ?? json['feedbackId']?.toString() ?? '',
      taskId: json['taskID']?.toString() ?? json['taskId']?.toString() ?? '',
      employerId: json['employerID']?.toString() ?? json['employerId']?.toString() ?? '',
      employeeId: json['employeeID']?.toString() ?? json['employeeId']?.toString() ?? '',
      feedbackText: json['feedbackText']?.toString(),
      rating: json['rating'] is int ? json['rating'] : int.tryParse(json['rating']?.toString() ?? ''),
      submittedDate: json['submittedDate'] != null ? DateTime.tryParse(json['submittedDate']) : null,
      improvementNotes: json['improvementNotes']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedbackID': feedbackId,
      'taskID': taskId,
      'employerID': employerId,
      'employeeID': employeeId,
      'feedbackText': feedbackText,
      'rating': rating,
      'submittedDate': submittedDate?.toIso8601String(),
      'improvementNotes': improvementNotes,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  static final _supabase = Supabase.instance.client;

  static Future<TaskFeedback?> fetchFeedback(String feedbackId) async {
    try {
      final response = await _supabase
          .from('task_feedback')
          .select()
          .eq('feedbackID', feedbackId)
          .maybeSingle();
      return response != null ? TaskFeedback.fromJson(response) : null;
    } catch (e) {
      print('Error fetching feedback: $e');
      return null;
    }
  }

  static Future<void> createFeedback(TaskFeedback feedback) async {
    try {
      await _supabase.from('task_feedback').insert(feedback.toJson());
    } catch (e) {
      print('Error creating feedback: $e');
      rethrow;
    }
  }

  static Future<void> updateFeedback(TaskFeedback feedback) async {
    try {
      await _supabase
          .from('task_feedback')
          .update(feedback.toJson())
          .eq('feedbackID', feedback.feedbackId);
    } catch (e) {
      print('Error updating feedback: $e');
      rethrow;
    }
  }
}
