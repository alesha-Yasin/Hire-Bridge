import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hirebridge/models/User.dart' as model;
import 'package:hirebridge/models/JobSeeker.dart';
import 'package:hirebridge/models/Employer.dart';

// Import all screens
import 'package:hirebridge/Frontend/LoginPages/intro_pages.dart';
import 'package:hirebridge/Frontend/LoginPages/login_page.dart';
import 'package:hirebridge/Frontend/UserData/user_type_selection.dart';
import 'package:hirebridge/Frontend/JobseekerData/Jobseeker_data_page.dart';
import 'package:hirebridge/Frontend/CompanyData/company_data_page.dart';
import 'package:hirebridge/Frontend/Profile/jobseeker_profile_page.dart';
import 'package:hirebridge/Frontend/Profile/employer_profile_page.dart';

/// Enum representing user's current state in the onboarding journey
enum UserJourneyState {
  needsIntro,           // First time user - needs to see intro pages
  needsLogin,           // Has seen intro but not logged in
  needsUserType,        // Logged in but hasn't selected user type
  needsUserDetails,     // Selected type but hasn't entered basic details
  needsProfileData,     // Has basic details but no profile (job seeker/employer)
  complete,             // Fully registered - go to profile
}

/// Service to handle navigation flow based on user's journey state
class NavigationService {
  static final _supabase = Supabase.instance.client;

  /// Determines the user's current state in the onboarding journey
  static Future<UserJourneyState> getUserJourneyState() async {
    try {
      // 1. Check if user has seen intro
      final prefs = await SharedPreferences.getInstance();
      final hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
      
      if (!hasSeenIntro) {
        return UserJourneyState.needsIntro;
      }

      // 2. Check if user is logged in
      final authUser = _supabase.auth.currentUser;
      if (authUser == null) {
        return UserJourneyState.needsLogin;
      }

      // 3. Check if user has basic user data in 'users' table
      final userData = await model.User.fetchUser(authUser.id);
      if (userData == null) {
        return UserJourneyState.needsUserType;
      }

      // 4. Check if user has completed their profile based on account type
      if (userData.accountType == 'Job Seeker') {
        final profile = await JobSeekerProfile.fetchByUserId(authUser.id);
        if (profile == null) {
          return UserJourneyState.needsProfileData;
        }
      } else if (userData.accountType == 'Employer') {
        final employer = await Employer.fetchByUserId(authUser.id);
        if (employer == null) {
          return UserJourneyState.needsProfileData;
        }
      }

      // 5. User has completed all steps
      return UserJourneyState.complete;
    } catch (e) {
      print('Error getting user journey state: $e');
      // Default to login if there's an error
      return UserJourneyState.needsLogin;
    }
  }

  /// Gets the appropriate destination screen based on user's journey state
  static Future<Widget> getDestinationScreen() async {
    final state = await getUserJourneyState();
    return getScreenForState(state);
  }

  /// Returns the widget for a given journey state
  static Widget getScreenForState(UserJourneyState state) {
    switch (state) {
      case UserJourneyState.needsIntro:
        return const IntroPages();
      case UserJourneyState.needsLogin:
        return const LoginPage();
      case UserJourneyState.needsUserType:
        return const UserTypeSelection();
      case UserJourneyState.needsUserDetails:
        // This shouldn't happen normally as user type leads to details
        return const UserTypeSelection();
      case UserJourneyState.needsProfileData:
        return const _ProfileDataRouter();
      case UserJourneyState.complete:
        return const _ProfileRouter();
    }
  }

  /// Navigate to the appropriate screen after login
  static Future<void> navigateAfterLogin(BuildContext context) async {
    final screen = await getDestinationScreen();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    }
  }

  /// Gets the user's account type
  static Future<String?> getUserAccountType() async {
    final authUser = _supabase.auth.currentUser;
    if (authUser == null) return null;
    
    final userData = await model.User.fetchUser(authUser.id);
    return userData?.accountType;
  }
}

/// Widget that routes to the appropriate profile data page
class _ProfileDataRouter extends StatelessWidget {
  const _ProfileDataRouter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: NavigationService.getUserAccountType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final accountType = snapshot.data;
        if (accountType == 'Job Seeker') {
          return const JobseekerDataPage();
        } else if (accountType == 'Employer') {
          return const CompanyDataPage();
        } else {
          // Fallback - shouldn't happen
          return const UserTypeSelection();
        }
      },
    );
  }
}

/// Widget that routes to the appropriate profile page
class _ProfileRouter extends StatelessWidget {
  const _ProfileRouter();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: NavigationService.getUserAccountType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final accountType = snapshot.data;
        if (accountType == 'Job Seeker') {
          return const JobSeekerProfilePage();
        } else if (accountType == 'Employer') {
          return const EmployerProfilePage();
        } else {
          // Fallback
          return const LoginPage();
        }
      },
    );
  }
}
