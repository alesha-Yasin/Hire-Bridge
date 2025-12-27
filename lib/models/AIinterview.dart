import 'package:supabase_flutter/supabase_flutter.dart';

class AIInterview {
  final String interviewId;
  final String? applicationId;
  final String seekerId;
  final DateTime? interviewDate;
  final String? interviewTime;
  final String? interviewMode;
  final String? meetingLink;
  final String? interviewerName;
  final String? interviewStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AIInterview({
    required this.interviewId,
    this.applicationId,
    required this.seekerId,
    this.interviewDate,
    this.interviewTime,
    this.interviewMode,
    this.meetingLink,
    this.interviewerName,
    this.interviewStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory AIInterview.fromJson(Map<String, dynamic> json) {
    return AIInterview(
      interviewId: json['interviewID']?.toString() ?? json['interviewId']?.toString() ?? '',
      applicationId: json['applicationID']?.toString() ?? json['applicationId']?.toString(),
      seekerId: json['seekerID']?.toString() ?? json['seekerId']?.toString() ?? '',
      interviewDate: json['interviewDate'] != null ? DateTime.tryParse(json['interviewDate']) : null,
      interviewTime: json['interviewTime']?.toString(),
      interviewMode: json['interviewMode']?.toString(),
      meetingLink: json['meetingLink']?.toString() ?? json['interviewLink']?.toString(),
      interviewerName: json['interviewerName']?.toString() ?? json['interviewName']?.toString(),
      interviewStatus: json['interviewStatus']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'interviewID': interviewId,
      'applicationID': applicationId,
      'seekerID': seekerId,
      'interviewDate': interviewDate?.toIso8601String(),
      'interviewTime': interviewTime,
      'interviewMode': interviewMode,
      'meetingLink': meetingLink,
      'interviewerName': interviewerName,
      'interviewStatus': interviewStatus,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static final _supabase = Supabase.instance.client;

  static Future<AIInterview?> fetchInterview(String interviewId) async {
    try {
      final response = await _supabase
          .from('ai_interviews')
          .select()
          .eq('interviewID', interviewId)
          .maybeSingle();
      return response != null ? AIInterview.fromJson(response) : null;
    } catch (e) {
      print('Error fetching interview: $e');
      return null;
    }
  }

  static Future<void> createInterview(AIInterview interview) async {
    try {
      await _supabase.from('ai_interviews').insert(interview.toJson());
    } catch (e) {
      print('Error creating interview: $e');
      rethrow;
    }
  }

  static Future<void> updateInterview(AIInterview interview) async {
    try {
      await _supabase
          .from('ai_interviews')
          .update(interview.toJson())
          .eq('interviewID', interview.interviewId);
    } catch (e) {
      print('Error updating interview: $e');
      rethrow;
    }
  }
}
