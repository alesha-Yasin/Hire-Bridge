import 'package:supabase_flutter/supabase_flutter.dart';

class Task {
  final String taskId;
  final String hireId;
  final String taskTitle;
  final String? taskDescription;
  final DateTime? assignedDate;
  final DateTime? deadlineDate;
  final String? priority;
  final String? taskStatus;
  final String? taskCategory;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Task({
    required this.taskId,
    required this.hireId,
    required this.taskTitle,
    this.taskDescription,
    this.assignedDate,
    this.deadlineDate,
    this.priority,
    this.taskStatus,
    this.taskCategory,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskID']?.toString() ?? json['taskId']?.toString() ?? '',
      hireId: json['hireID']?.toString() ?? json['hireId']?.toString() ?? '',
      taskTitle: json['taskTitle']?.toString() ?? '',
      taskDescription: json['taskDescription']?.toString(),
      assignedDate: json['assignedDate'] != null ? DateTime.tryParse(json['assignedDate']) : null,
      deadlineDate: json['deadlineDate'] != null ? DateTime.tryParse(json['deadlineDate']) : null,
      priority: json['priority']?.toString(),
      taskStatus: json['taskStatus']?.toString(),
      taskCategory: json['taskCategory']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskID': taskId,
      'hireID': hireId,
      'taskTitle': taskTitle,
      'taskDescription': taskDescription,
      'assignedDate': assignedDate?.toIso8601String(),
      'deadlineDate': deadlineDate?.toIso8601String(),
      'priority': priority,
      'taskStatus': taskStatus,
      'taskCategory': taskCategory,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static final _supabase = Supabase.instance.client;

  static Future<Task?> fetchTask(String taskId) async {
    try {
      final response = await _supabase
          .from('tasks')
          .select()
          .eq('taskID', taskId)
          .maybeSingle();
      return response != null ? Task.fromJson(response) : null;
    } catch (e) {
      print('Error fetching task: $e');
      return null;
    }
  }

  static Future<void> createTask(Task task) async {
    try {
      await _supabase.from('tasks').insert(task.toJson());
    } catch (e) {
      print('Error creating task: $e');
      rethrow;
    }
  }

  static Future<void> updateTask(Task task) async {
    try {
      await _supabase
          .from('tasks')
          .update(task.toJson())
          .eq('taskID', task.taskId);
    } catch (e) {
      print('Error updating task: $e');
      rethrow;
    }
  }
}
