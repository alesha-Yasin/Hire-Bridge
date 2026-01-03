import 'package:supabase_flutter/supabase_flutter.dart';

class User {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String email;
  final String password;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? phone;
  final String? city;
  final String? country;
  final String? profileImage;
  final String? accountType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.userId,
    this.firstName,
    this.lastName,
    required this.email,
    required this.password,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.city,
    this.country,
    this.profileImage,
    this.accountType,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userID']?.toString() ?? json['userId']?.toString() ?? '',
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      gender: json['gender']?.toString(),
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.tryParse(json['dateOfBirth']) : null,
      phone: json['phone']?.toString(),
      city: json['city']?.toString(),
      country: json['country']?.toString(),
      profileImage: json['profileImage']?.toString(),
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
      'email': email,
      'password': password,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phone': phone,
      'city': city,
      'country': country,
      'profileImage': profileImage,
      'accountType': accountType,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
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
