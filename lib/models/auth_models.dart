class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, String> toJson() => {
    'email': email,
    'password': password,
  };
}

class SignUpRequest {
  final String email;
  final String password;
  final String? phone;

  SignUpRequest({
    required this.email,
    required this.password,
    this.phone,
  });

  Map<String, String> toJson() {
    final map = {
      'email': email,
      'password': password,
    };
    if (phone != null) map['phone'] = phone!;
    return map;
  }
}
