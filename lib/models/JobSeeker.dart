import 'package:supabase_flutter/supabase_flutter.dart';

class JobSeekerProfile {
  final String seekerId;
  final String userId;
  final String? bio;
  final String? educationLevel;
  final List<String>? skillsList;
  final int? experienceYears;
  final String? desiredSalary;
  final String? desiredJobType;
  final String? resumeUrl;
  final String? portfolioUrl;
  final String? availabilityStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  JobSeekerProfile({
    required this.seekerId,
    required this.userId,
    this.bio,
    this.educationLevel,
    this.skillsList,
    this.experienceYears,
    this.desiredSalary,
    this.desiredJobType,
    this.resumeUrl,
    this.portfolioUrl,
    this.availabilityStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory JobSeekerProfile.fromJson(Map<String, dynamic> json) {
    return JobSeekerProfile(
      seekerId: json['seekerID']?.toString() ?? json['seekerId']?.toString() ?? '',
      userId: json['userID']?.toString() ?? json['userId']?.toString() ?? '',
      bio: json['bio']?.toString(),
      educationLevel: json['educationLevel']?.toString(),
      skillsList: json['skillsList'] != null ? List<String>.from(json['skillsList']) : [],
      experienceYears: json['experienceYears'] is int ? json['experienceYears'] : int.tryParse(json['experienceYears']?.toString() ?? ''),
      desiredSalary: json['desiredSalary']?.toString(),
      desiredJobType: json['desiredJobType']?.toString(),
      resumeUrl: json['resumeURL']?.toString() ?? json['resumeUrl']?.toString(),
      portfolioUrl: json['portfolioURL']?.toString() ?? json['portfolioUrl']?.toString(),
      availabilityStatus: json['availabilityStatus']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seekerID': seekerId,
      'userID': userId,
      'bio': bio,
      'educationLevel': educationLevel,
      'skillsList': skillsList,
      'experienceYears': experienceYears,
      'desiredSalary': desiredSalary,
      'desiredJobType': desiredJobType,
      'resumeURL': resumeUrl,
      'portfolioURL': portfolioUrl,
      'availabilityStatus': availabilityStatus,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static final _supabase = Supabase.instance.client;

  static Future<JobSeekerProfile?> fetchByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('job_seeker_profiles')
          .select()
          .eq('userID', userId)
          .maybeSingle();
      return response != null ? JobSeekerProfile.fromJson(response) : null;
    } catch (e) {
      print('Error fetching job seeker profile: $e');
      return null;
    }
  }

  static Future<void> createProfile(JobSeekerProfile profile) async {
    try {
      await _supabase.from('job_seeker_profiles').insert(profile.toJson());
    } catch (e) {
      print('Error creating job seeker profile: $e');
      rethrow;
    }
  }

  static Future<void> updateProfile(JobSeekerProfile profile) async {
    try {
      await _supabase
          .from('job_seeker_profiles')
          .update(profile.toJson())
          .eq('seekerID', profile.seekerId);
    } catch (e) {
      print('Error updating job seeker profile: $e');
      rethrow;
    }
  }
}
