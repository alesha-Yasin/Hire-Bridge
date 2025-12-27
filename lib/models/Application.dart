import 'package:supabase_flutter/supabase_flutter.dart';

class Application {
  final String applicationId;
  final String jobId;
  final String seekerId;
  final DateTime? appliedDate;
  final String? applicationStatus;
  final String? remarksByEmployer;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Application({
    required this.applicationId,
    required this.jobId,
    required this.seekerId,
    this.appliedDate,
    this.applicationStatus,
    this.remarksByEmployer,
    this.createdAt,
    this.updatedAt,
  });

  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      applicationId: json['applicationID']?.toString() ?? json['applicationId']?.toString() ?? '',
      jobId: json['jobID']?.toString() ?? json['jobId']?.toString() ?? '',
      seekerId: json['seekerID']?.toString() ?? json['seekerId']?.toString() ?? '',
      appliedDate: json['appliedDate'] != null ? DateTime.tryParse(json['appliedDate']) : null,
      applicationStatus: json['applicationStatus']?.toString(),
      remarksByEmployer: json['remarksByEmployer']?.toString() ?? json['remarksbyEmployer']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'applicationID': applicationId,
      'jobID': jobId,
      'seekerID': seekerId,
      'appliedDate': appliedDate?.toIso8601String(),
      'applicationStatus': applicationStatus,
      'remarksByEmployer': remarksByEmployer,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static final _supabase = Supabase.instance.client;

  static Future<Application?> fetchApplication(String applicationId) async {
    try {
      final response = await _supabase
          .from('applications')
          .select()
          .eq('applicationID', applicationId)
          .maybeSingle();
      return response != null ? Application.fromJson(response) : null;
    } catch (e) {
      print('Error fetching application: $e');
      return null;
    }
  }

  static Future<void> createApplication(Application application) async {
    try {
      await _supabase.from('applications').insert(application.toJson());
    } catch (e) {
      print('Error creating application: $e');
      rethrow;
    }
  }

  static Future<void> updateApplication(Application application) async {
    try {
      await _supabase
          .from('applications')
          .update(application.toJson())
          .eq('applicationID', application.applicationId);
    } catch (e) {
      print('Error updating application: $e');
      rethrow;
    }
  }
}
