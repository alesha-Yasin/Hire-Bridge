import 'package:supabase_flutter/supabase_flutter.dart';

class HiringRecord {
  final String hireId;
  final String applicationId;
  final DateTime? hireDate;
  final DateTime? joiningDate;
  final String? contractDuration;
  final double? salary;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  HiringRecord({
    required this.hireId,
    required this.applicationId,
    this.hireDate,
    this.joiningDate,
    this.contractDuration,
    this.salary,
    this.createdAt,
    this.updatedAt,
  });

  factory HiringRecord.fromJson(Map<String, dynamic> json) {
    return HiringRecord(
      hireId: json['hireID']?.toString() ?? json['hireId']?.toString() ?? '',
      applicationId: json['applicationID']?.toString() ?? json['applicationId']?.toString() ?? '',
      hireDate: json['hireDate'] != null ? DateTime.tryParse(json['hireDate']) : null,
      joiningDate: json['joiningDate'] != null ? DateTime.tryParse(json['joiningDate']) : null,
      contractDuration: json['contractDuration']?.toString(),
      salary: json['salary'] != null ? (json['salary'] as num).toDouble() : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hireID': hireId,
      'applicationID': applicationId,
      'hireDate': hireDate?.toIso8601String(),
      'joiningDate': joiningDate?.toIso8601String(),
      'contractDuration': contractDuration,
      'salary': salary,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static final _supabase = Supabase.instance.client;

  static Future<HiringRecord?> fetchHiringRecord(String hireId) async {
    try {
      final response = await _supabase
          .from('hiring_records')
          .select()
          .eq('hireID', hireId)
          .maybeSingle();
      return response != null ? HiringRecord.fromJson(response) : null;
    } catch (e) {
      print('Error fetching hiring record: $e');
      return null;
    }
  }

  static Future<void> createHiringRecord(HiringRecord record) async {
    try {
      await _supabase.from('hiring_records').insert(record.toJson());
    } catch (e) {
      print('Error creating hiring record: $e');
      rethrow;
    }
  }

  static Future<void> updateHiringRecord(HiringRecord record) async {
    try {
      await _supabase
          .from('hiring_records')
          .update(record.toJson())
          .eq('hireID', record.hireId);
    } catch (e) {
      print('Error updating hiring record: $e');
      rethrow;
    }
  }
}
