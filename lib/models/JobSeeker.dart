import 'package:supabase_flutter/supabase_flutter.dart';

class JobSeekerProfile {
  final String seekerId;
  final String userId;
  final String? bio;
  final List<dynamic>? skillsList;
  final int? experienceYears;
  final String? headline;
  final String? about;
  final List<String> currentPositions;
  final String? desiredSalary;
  final String? desiredJobType;
  final String? resumeUrl;
  final String? profileUrl;
  final String? address;
  final int? internshipsCount;
  final int? projectsCount;
  final List<dynamic>? projects;
  final List<dynamic>? detailedExperience;
  final List<dynamic>? detailedEducation;
  final String? availabilityStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  JobSeekerProfile({
    required this.seekerId,
    required this.userId,
    this.bio,
    this.skillsList,
    this.experienceYears,
    this.headline,
    this.about,
    this.currentPositions = const [],
    this.desiredSalary,
    this.desiredJobType,
    this.resumeUrl,
    this.profileUrl,
    this.address,
    this.internshipsCount,
    this.projectsCount,
    this.projects,
    this.detailedExperience,
    this.detailedEducation,
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
      currentPositions: json['currentPositions'] != null 
          ? List<String>.from(json['currentPositions'].map((x) => x.toString()))
          : (json['currentPosition'] != null ? [json['currentPosition'].toString()] : []),
      desiredSalary: json['desiredSalary']?.toString(),
      desiredJobType: json['desiredJobType']?.toString(),
      resumeUrl: json['resumeURL']?.toString() ?? json['resumeUrl']?.toString(),
      profileUrl: json['profileURL']?.toString() ?? json['profileUrl']?.toString(),
      address: json['address']?.toString(),
      internshipsCount: json['internshipsCount'] is int ? json['internshipsCount'] : int.tryParse(json['internshipsCount']?.toString() ?? '0'),
      projectsCount: json['projectsCount'] is int ? json['projectsCount'] : int.tryParse(json['projectsCount']?.toString() ?? '0'),
      projects: json['job_seeker_projects'] as List<dynamic>?,
      skillsList: json['job_seeker_skills'] as List<dynamic>?,
      detailedExperience: json['job_seeker_experience'] as List<dynamic>?,
      detailedEducation: json['job_seeker_education'] as List<dynamic>?,
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
      'currentPositions': currentPositions,
      'desiredSalary': desiredSalary,
      'desiredJobType': desiredJobType,
      'resumeURL': resumeUrl,
      'profileURL': profileUrl,
      'address': address,
      'internshipsCount': internshipsCount,
      'projectsCount': projectsCount,
      'availabilityStatus': availabilityStatus,
    };
  }

  JobSeekerProfile copyWith({
    String? seekerId,
    String? userId,
    String? bio,
    List<dynamic>? skillsList,
    int? experienceYears,
    String? headline,
    String? about,
    List<String>? currentPositions,
    String? desiredSalary,
    String? desiredJobType,
    String? resumeUrl,
    String? profileUrl,
    String? address,
    int? internshipsCount,
    int? projectsCount,
    List<dynamic>? projects,
    List<dynamic>? detailedExperience,
    List<dynamic>? detailedEducation,
    String? availabilityStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JobSeekerProfile(
      seekerId: seekerId ?? this.seekerId,
      userId: userId ?? this.userId,
      bio: bio ?? this.bio,
      skillsList: skillsList ?? this.skillsList,
      experienceYears: experienceYears ?? this.experienceYears,
      headline: headline ?? this.headline,
      about: about ?? this.about,
      currentPositions: currentPositions ?? this.currentPositions,
      desiredSalary: desiredSalary ?? this.desiredSalary,
      desiredJobType: desiredJobType ?? this.desiredJobType,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      profileUrl: profileUrl ?? this.profileUrl,
      address: address ?? this.address,
      internshipsCount: internshipsCount ?? this.internshipsCount,
      projectsCount: projectsCount ?? this.projectsCount,
      projects: projects ?? this.projects,
      detailedExperience: detailedExperience ?? this.detailedExperience,
      detailedEducation: detailedEducation ?? this.detailedEducation,
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
          .select('*, job_seeker_projects(*), job_seeker_skills(*), job_seeker_experience(*), job_seeker_education(*)')
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

      // 2. Sync Projects
      if (profile.projects != null) {
        await _supabase.from('job_seeker_projects').delete().eq('seekerID', profile.seekerId);
        if (profile.projects!.isNotEmpty) {
          final projectsToInsert = profile.projects!.map((p) {
            if (p is! Map) throw 'Project data must be a Map, got ${p.runtimeType}';
            return {
              'seekerID': profile.seekerId,
              'name': p['name'],
              'description': p['description'],
              'languages': p['languages'],
              'tools': p['tools'],
              'githubUrl': p['githubUrl'],
            };
          }).toList();
          await _supabase.from('job_seeker_projects').insert(projectsToInsert);
        }
      }

      // 3. Sync Skills
      if (profile.skillsList != null) {
        await _supabase.from('job_seeker_skills').delete().eq('seekerID', profile.seekerId);
        if (profile.skillsList!.isNotEmpty) {
          final skillsToInsert = profile.skillsList!.map((s) {
            if (s is! Map) throw 'Skill data must be a Map, got ${s.runtimeType}';
            return {
              'seekerID': profile.seekerId,
              'name': s['name'],
              'projectName': s['projectName'],
              'workWith': s['workWith'],
            };
          }).toList();
          await _supabase.from('job_seeker_skills').insert(skillsToInsert);
        }
      }

      // 4. Sync Experience
      if (profile.detailedExperience != null) {
        await _supabase.from('job_seeker_experience').delete().eq('seekerID', profile.seekerId);
        if (profile.detailedExperience!.isNotEmpty) {
          final experienceToInsert = profile.detailedExperience!.map((exp) {
            if (exp is! Map) throw 'Experience data must be a Map, got ${exp.runtimeType}';
            return {
              'seekerID': profile.seekerId,
              'company': exp['company'],
              'role': exp['role'],
              'period': exp['period'],
              'description': exp['description'],
            };
          }).toList();
          await _supabase.from('job_seeker_experience').insert(experienceToInsert);
        }
      // 5. Sync Education
      if (profile.detailedEducation != null) {
        await _supabase.from('job_seeker_education').delete().eq('seekerID', profile.seekerId);
        if (profile.detailedEducation!.isNotEmpty) {
          final educationToInsert = profile.detailedEducation!.map((edu) {
            if (edu is! Map) throw 'Education data must be a Map, got ${edu.runtimeType}';
            return {
              'seekerID': profile.seekerId,
              'degree': edu['degree'],
              'school': edu['school'],
              'year': edu['year'],
              'grade': edu['grade'],
            };
          }).toList();
          await _supabase.from('job_seeker_education').insert(educationToInsert);
        }
      }
    }} catch (e) {
      print('Error updating job seeker profile: $e');
      rethrow;
    }
  }
}

