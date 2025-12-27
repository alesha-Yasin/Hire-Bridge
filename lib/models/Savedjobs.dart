import 'package:supabase_flutter/supabase_flutter.dart';

class SavedJobs {
  final String savedId;
  final String seekerId;
  final String jobId;
  final DateTime? savedAt;

  SavedJobs({
    required this.savedId,
    required this.seekerId,
    required this.jobId,
    this.savedAt,
  });

  factory SavedJobs.fromJson(Map<String, dynamic> json) {
    return SavedJobs(
      savedId: json['savedID']?.toString() ?? json['savedId']?.toString() ?? '',
      seekerId: json['seekerID']?.toString() ?? json['seekerId']?.toString() ?? '',
      jobId: json['jobID']?.toString() ?? json['jobId']?.toString() ?? '',
      savedAt: json['savedAt'] != null ? DateTime.tryParse(json['savedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'savedID': savedId,
      'seekerID': seekerId,
      'jobID': jobId,
      'savedAt': savedAt?.toIso8601String(),
    };
  }

  static final _supabase = Supabase.instance.client;

  static Future<List<SavedJobs>> fetchSavedJobs(String seekerId) async {
    try {
      final response = await _supabase
          .from('saved_jobs')
          .select()
          .eq('seekerID', seekerId);
      return (response as List).map((json) => SavedJobs.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching saved jobs: $e');
      return [];
    }
  }

  static Future<void> saveJob(SavedJobs savedJob) async {
    try {
      await _supabase.from('saved_jobs').insert(savedJob.toJson());
    } catch (e) {
      print('Error saving job: $e');
      rethrow;
    }
  }

  static Future<void> removeSavedJob(String savedId) async {
    try {
      await _supabase.from('saved_jobs').delete().eq('savedID', savedId);
    } catch (e) {
      print('Error removing saved job: $e');
      rethrow;
    }
  }
}