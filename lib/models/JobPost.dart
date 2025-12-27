import 'package:supabase_flutter/supabase_flutter.dart';

class JobPost {
  final String jobId;
  final String employerId;
  final String jobTitle;
  final String? jobCategory;
  final String? jobType;
  final String? jobDescription;
  final List<String>? requiredSkills;
  final int? experienceRequired;
  final String? location;
  final String? workMode;
  final DateTime? postedDate;
  final DateTime? lastDateToApply;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  JobPost({
    required this.jobId,
    required this.employerId,
    required this.jobTitle,
    this.jobCategory,
    this.jobType,
    this.jobDescription,
    this.requiredSkills,
    this.experienceRequired,
    this.location,
    this.workMode,
    this.postedDate,
    this.lastDateToApply,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      jobId: json['jobID']?.toString() ?? json['jobId']?.toString() ?? '',
      employerId: json['employerID']?.toString() ?? json['employerId']?.toString() ?? '',
      jobTitle: json['jobTitle']?.toString() ?? '',
      jobCategory: json['jobCategory']?.toString(),
      jobType: json['jobType']?.toString(),
      jobDescription: json['jobDescription']?.toString(),
      requiredSkills: json['requiredSkills'] != null ? List<String>.from(json['requiredSkills']) : [],
      experienceRequired: json['experienceRequired'] is int ? json['experienceRequired'] : int.tryParse(json['experienceRequired']?.toString() ?? ''),
      location: json['location']?.toString(),
      workMode: json['workMode']?.toString(),
      postedDate: json['postedDate'] != null ? DateTime.tryParse(json['postedDate']) : null,
      lastDateToApply: json['lastDateToApply'] != null ? DateTime.tryParse(json['lastDateToApply']) : null,
      status: json['status']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jobID': jobId,
      'employerID': employerId,
      'jobTitle': jobTitle,
      'jobCategory': jobCategory,
      'jobType': jobType,
      'jobDescription': jobDescription,
      'requiredSkills': requiredSkills,
      'experienceRequired': experienceRequired,
      'location': location,
      'workMode': workMode,
      'postedDate': postedDate?.toIso8601String(),
      'lastDateToApply': lastDateToApply?.toIso8601String(),
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static final _supabase = Supabase.instance.client;

  static Future<List<JobPost>> fetchActiveJobs() async {
    try {
      final response = await _supabase
          .from('job_posts')
          .select()
          .eq('status', 'Active');
      return (response as List).map((json) => JobPost.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching jobs: $e');
      return [];
    }
  }

  static Future<JobPost?> fetchJobPost(String jobId) async {
    try {
      final response = await _supabase
          .from('job_posts')
          .select()
          .eq('jobID', jobId)
          .maybeSingle();
      return response != null ? JobPost.fromJson(response) : null;
    } catch (e) {
      print('Error fetching job post: $e');
      return null;
    }
  }

  static Future<void> createJobPost(JobPost job) async {
    try {
      await _supabase.from('job_posts').insert(job.toJson());
    } catch (e) {
      print('Error creating job post: $e');
      rethrow;
    }
  }

  static Future<void> updateJobPost(JobPost job) async {
    try {
      await _supabase
          .from('job_posts')
          .update(job.toJson())
          .eq('jobID', job.jobId);
    } catch (e) {
      print('Error updating job post: $e');
      rethrow;
    }
  }

  static Future<void> deleteJobPost(String jobId) async {
    try {
      await _supabase.from('job_posts').delete().eq('jobID', jobId);
    } catch (e) {
      print('Error deleting job post: $e');
      rethrow;
    }
  }
}
