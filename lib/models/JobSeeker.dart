import 'package:supabase_flutter/supabase_flutter.dart';

class JobSeekerProfile {
  final String seekerId;
  final String userId;
  final String? bio;
  final List<dynamic>? educationLevel;
  final List<dynamic>? skillsList;
  final int? experienceYears;
  final String? headline;
  final String? about;
  final String? currentPosition;
  final String? desiredSalary;
  final String? desiredJobType;
  final String? resumeUrl;
  final String? profileUrl;
  final String? address;
  final int? internshipsCount;
  final int? projectsCount;
  final List<dynamic>? projects;
  final List<dynamic>? detailedExperience;
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
    this.headline,
    this.about,
    this.currentPosition,
    this.desiredSalary,
    this.desiredJobType,
    this.resumeUrl,
    this.profileUrl,
    this.address,
    this.internshipsCount,
    this.projectsCount,
    this.projects,
    this.detailedExperience,
    this.availabilityStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory JobSeekerProfile.fromJson(Map<String, dynamic> json) {
    return JobSeekerProfile(
      seekerId: json['seekerID']?.toString() ?? json['seekerId']?.toString() ?? '',
      userId: json['userID']?.toString() ?? json['userId']?.toString() ?? '',
      bio: json['bio']?.toString(),
      experienceYears: json['experienceYears'] is int ? json['experienceYears'] : int.tryParse(json['experienceYears']?.toString() ?? ''),
      headline: json['headline']?.toString(),
      about: json['about']?.toString(),
      currentPosition: json['currentPosition']?.toString(),
      desiredSalary: json['desiredSalary']?.toString(),
      desiredJobType: json['desiredJobType']?.toString(),
      resumeUrl: json['resumeURL']?.toString() ?? json['resumeUrl']?.toString(),
      profileUrl: json['profileURL']?.toString() ?? json['profileUrl']?.toString(),
      address: json['address']?.toString(),
      internshipsCount: json['internshipsCount'] is int ? json['internshipsCount'] : int.tryParse(json['internshipsCount']?.toString() ?? '0'),
      projectsCount: json['projectsCount'] is int ? json['projectsCount'] : int.tryParse(json['projectsCount']?.toString() ?? '0'),
      projects: json['job_seeker_projects'] as List<dynamic>?,
      skillsList: json['job_seeker_skills'] as List<dynamic>?,
      educationLevel: json['job_seeker_education'] as List<dynamic>?,
      detailedExperience: json['job_seeker_experience'] as List<dynamic>?,
      availabilityStatus: json['availabilityStatus']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seekerID': seekerId,
      'userID': userId,
      'bio': bio,
      'experienceYears': experienceYears,
      'headline': headline,
      'about': about,
      'currentPosition': currentPosition,
      'desiredSalary': desiredSalary,
      'desiredJobType': desiredJobType,
      'resumeURL': resumeUrl,
      'profileURL': profileUrl,
      'address': address,
      'internshipsCount': internshipsCount,
      'projectsCount': projectsCount,
      'availabilityStatus': availabilityStatus,
      // educationLevel, skillsList, projects, and detailedExperience are handled by separate tables
      // createdAt and updatedAt are typically handled by DB triggers
    };
  }

  JobSeekerProfile copyWith({
    String? seekerId,
    String? userId,
    String? bio,
    List<dynamic>? educationLevel,
    List<dynamic>? skillsList,
    int? experienceYears,
    String? headline,
    String? about,
    String? currentPosition,
    String? desiredSalary,
    String? desiredJobType,
    String? resumeUrl,
    String? profileUrl,
    String? address,
    int? internshipsCount,
    int? projectsCount,
    List<dynamic>? projects,
    List<dynamic>? detailedExperience,
    String? availabilityStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JobSeekerProfile(
      seekerId: seekerId ?? this.seekerId,
      userId: userId ?? this.userId,
      bio: bio ?? this.bio,
      educationLevel: educationLevel ?? this.educationLevel,
      skillsList: skillsList ?? this.skillsList,
      experienceYears: experienceYears ?? this.experienceYears,
      headline: headline ?? this.headline,
      about: about ?? this.about,
      currentPosition: currentPosition ?? this.currentPosition,
      desiredSalary: desiredSalary ?? this.desiredSalary,
      desiredJobType: desiredJobType ?? this.desiredJobType,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      profileUrl: profileUrl ?? this.profileUrl,
      address: address ?? this.address,
      internshipsCount: internshipsCount ?? this.internshipsCount,
      projectsCount: projectsCount ?? this.projectsCount,
      projects: projects ?? this.projects,
      detailedExperience: detailedExperience ?? this.detailedExperience,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static final _supabase = Supabase.instance.client;

  static Future<JobSeekerProfile?> fetchByUserId(String userId) async {
    try {
      final response = await _supabase
          .from('job_seeker_profiles')
          .select('*, job_seeker_projects(*), job_seeker_skills(*), job_seeker_education(*), job_seeker_experience(*)')
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
      // 1. Update the main profile table
      await _supabase
          .from('job_seeker_profiles')
          .update(profile.toJson())
          .eq('seekerID', profile.seekerId);

      // 2. Sync Projects (Delete old, insert new)
      if (profile.projects != null) {
        await _supabase.from('job_seeker_projects').delete().eq('seekerID', profile.seekerId);
        if (profile.projects!.isNotEmpty) {
          final projectsToInsert = profile.projects!.map((p) => {
            'seekerID': profile.seekerId,
            'name': p['name'],
            'description': p['description'],
            'languages': p['languages'],
            'tools': p['tools'],
            'githubUrl': p['githubUrl'],
          }).toList();
          await _supabase.from('job_seeker_projects').insert(projectsToInsert);
        }
      }

      // 3. Sync Skills
      if (profile.skillsList != null) {
        await _supabase.from('job_seeker_skills').delete().eq('seekerID', profile.seekerId);
        if (profile.skillsList!.isNotEmpty) {
          final skillsToInsert = profile.skillsList!.map((s) => {
            'seekerID': profile.seekerId,
            'name': s['name'],
            'projectName': s['projectName'],
            'workWith': s['workWith'],
          }).toList();
          await _supabase.from('job_seeker_skills').insert(skillsToInsert);
        }
      }

      // 4. Sync Education
      if (profile.educationLevel != null) {
        await _supabase.from('job_seeker_education').delete().eq('seekerID', profile.seekerId);
        if (profile.educationLevel!.isNotEmpty) {
          final educationToInsert = profile.educationLevel!.map((e) => {
            'seekerID': profile.seekerId,
            'degree': e['degree'],
            'institution': e['institution'],
            'year': e['year'],
          }).toList();
          await _supabase.from('job_seeker_education').insert(educationToInsert);
        }
      }

      // 5. Sync Experience
      if (profile.detailedExperience != null) {
        await _supabase.from('job_seeker_experience').delete().eq('seekerID', profile.seekerId);
        if (profile.detailedExperience!.isNotEmpty) {
          final experienceToInsert = profile.detailedExperience!.map((exp) => {
            'seekerID': profile.seekerId,
            'company': exp['company'],
            'role': exp['role'],
            'period': exp['period'],
            'description': exp['description'],
          }).toList();
          await _supabase.from('job_seeker_experience').insert(experienceToInsert);
        }
      }
    } catch (e) {
      print('Error updating job seeker profile: $e');
      rethrow;
    }
  }
}
