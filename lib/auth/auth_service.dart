import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hirebridge/models/auth_models.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. SIGN IN with Email and Password
  Future<AuthResponse> signIn(LoginRequest request) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: request.email.trim(),
        password: request.password.trim(),
      );
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  // 2. SIGN UP with Email and Password
  Future<AuthResponse> signUp(SignUpRequest request) async {
    try {
      return await _supabase.auth.signUp(
        email: request.email.trim(),
        password: request.password.trim(),
        data: request.phone != null ? {'phone': request.phone} : null,
      );
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  // 3. SEND OTP (for Login or Password Reset)
  Future<void> sendOTP(String email) async {
    try {
      await _supabase.auth.signInWithOtp(email: email.trim());
      print("OTP sent to $email");
    } catch (e) {
      print('Error sending OTP: $e');
      rethrow;
    }
  }

  // 3b. SEND SMS OTP
  Future<void> sendSMSOTP(String phone) async {
    try {
      await _supabase.auth.signInWithOtp(phone: phone.trim());
      print("OTP sent to phone: $phone");
    } catch (e) {
      print('Error sending SMS OTP: $e');
      rethrow;
    }
  }

  // 4. VERIFY OTP
  Future<AuthResponse> verifyOTP({
    required String token,
    String? email,
    String? phone,
    required OtpType type,
  }) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: type,
        email: email?.trim(),
        phone: phone?.trim(),
        token: token.trim(),
      );
      print("User verified: ${response.user?.id}");
      return response;
    } catch (e) {
      print('Error verifying OTP: $e');
      rethrow;
    }
  }

  // 5. RESET PASSWORD (Triggers email)
  Future<void> requestPasswordReset(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email.trim());
    } catch (e) {
      print('Error requesting password reset: $e');
      rethrow;
    }
  }

  // 6. UPDATE PASSWORD
  Future<void> updatePassword(String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      print('Error updating password: $e');
      rethrow;
    }
  }

  // 7. SIGN OUT
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // 8. GET CURRENT USER
  User? get currentUser => _supabase.auth.currentUser;

  String? get currentUserEmail => _supabase.auth.currentUser?.email;
}