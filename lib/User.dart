// user.dart
// Base User Class - Foundation for all users (Job Seekers and Employers)

class User {
  // Primary Key
  String? userID;
  
  // Basic Information
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  
  // Personal Details
  String? gender;
  DateTime? dateOfBirth;
  String? phone;
  String? country;
  
  // Profile Configuration
  String? profileType; // "Job Seeker" or "Employer"
  String? profilePicture; // URL to profile image
  
  // Timestamps
  DateTime? createdAt;
  DateTime? updatedAt;

  // Constructor
  User({
    this.userID,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.gender,
    this.dateOfBirth,
    this.phone,
    this.country,
    this.profileType,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
  });

  // ==================== JSON SERIALIZATION ====================
  
  // Convert User object to JSON Map (for sending data to Supabase)
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'gender': gender,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'phone': phone,
      'country': country,
      'profileType': profileType,
      'profilePicture': profilePicture,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create User object from JSON Map (for receiving data from Supabase)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'] != null 
          ? DateTime.parse(json['dateOfBirth']) 
          : null,
      phone: json['phone'],
      country: json['country'],
      profileType: json['profileType'],
      profilePicture: json['profilePicture'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  // ==================== UTILITY METHODS ====================
  
  // Copy with method - Create a copy with updated fields
  User copyWith({
    String? userID,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? gender,
    DateTime? dateOfBirth,
    String? phone,
    String? country,
    String? profileType,
    String? profilePicture,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      userID: userID ?? this.userID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      profileType: profileType ?? this.profileType,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get full name
  String getFullName() {
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  // Check if user is Job Seeker
  bool isJobSeeker() {
    return profileType?.toLowerCase() == 'job seeker';
  }

  // Check if user is Employer
  bool isEmployer() {
    return profileType?.toLowerCase() == 'employer';
  }

  // Get age from date of birth
  int? getAge() {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month || 
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  // Validate email format
  bool isValidEmail() {
    if (email == null) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email!);
  }

  // Validate phone format (basic)
  bool isValidPhone() {
    if (phone == null) return false;
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    return phoneRegex.hasMatch(phone!);
  }

  // Check if profile is complete
  bool isProfileComplete() {
    return firstName != null &&
           lastName != null &&
           email != null &&
           phone != null &&
           country != null &&
           profileType != null;
  }

  // ==================== PRINT/DEBUG ====================
  
  @override
  String toString() {
    return 'User(userID: $userID, name: ${getFullName()}, email: $email, type: $profileType)';
  }
}

// ==================== RELATIONSHIPS ====================
// This User class is linked to:
// 1. JobSeekerProfile (userID as Foreign Key)
// 2. Employer (userID as Foreign Key)
// 3. Notification (userID as receiver)
// 4. ChatMessage (senderID and receiverID as Foreign Keys)