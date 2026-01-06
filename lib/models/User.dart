import 'package:supabase_flutter/supabase_flutter.dart';

class User {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? phone;
  final String? city;
  final String? country;
  final String? profileImage;
  final String? address;
  final String? accountType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.userId,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.city,
    this.country,
    this.profileImage,
    this.address,
    this.accountType,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userID']?.toString() ?? json['userId']?.toString() ?? '',
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      gender: json['gender']?.toString(),
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth']) : null,
      phone: json['phone']?.toString(),
      city: json['city']?.toString(),
      country: json['country']?.toString(),
      profileImage: json['profileImage']?.toString(),
      address: json['address']?.toString(),
      accountType: json['accountType']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userId,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phone': phone,
      'city': city,
      'country': country,
      'profileImage': profileImage,
      'address': address,
      'accountType': accountType,
      // createdAt and updatedAt are handled by DB triggers
    };
  }

  static final _supabase = Supabase.instance.client;

  static Future<User?> fetchUser(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('userID', userId)
          .maybeSingle();
      return response != null ? User.fromJson(response) : null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  static Future<void> createUser(User user) async {
    try {
      await _supabase.from('users').insert(user.toJson());
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  static Future<void> updateUser(User user) async {
    try {
      await _supabase
          .from('users')
          .update(user.toJson())
          .eq('userID', user.userId);
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }
}
