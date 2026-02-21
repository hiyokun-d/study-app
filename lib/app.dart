import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/auth/screens/role_selection_screen.dart';
import 'features/student/screens/student_dashboard.dart';
import 'features/student/screens/course_detail_screen.dart';
import 'features/student/screens/live_class_screen.dart';
import 'features/teacher/screens/teacher_dashboard.dart';
import 'features/chat/screens/chat_detail_screen.dart';
import 'features/subscription/screens/subscription_plans_screen.dart';
import 'features/subscription/screens/payment_screen.dart';
import 'features/subscription/screens/payment_success_screen.dart';
import 'routes/app_routes.dart';

/// Main application widget
class StudyApp extends StatelessWidget {
  const StudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      routes: {
        // Auth routes
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.roleSelection: (context) => const RoleSelectionScreen(),
        
        // Student routes
        AppRoutes.studentDashboard: (context) => const StudentDashboard(),
        AppRoutes.courseDetail: (context) => const CourseDetailScreen(),
        AppRoutes.liveClass: (context) => const LiveClassScreen(),
        
        // Teacher routes
        AppRoutes.teacherDashboard: (context) => const TeacherDashboard(),
        
        // Chat routes
        AppRoutes.chatDetail: (context) => const ChatDetailScreen(),
        
        // Subscription routes
        AppRoutes.subscriptionPlans: (context) => const SubscriptionPlansScreen(),
        AppRoutes.payment: (context) => const PaymentScreen(),
        AppRoutes.paymentSuccess: (context) => const PaymentSuccessScreen(),
      },
      onGenerateRoute: (settings) {
        // Handle routes with arguments here
        switch (settings.name) {
          default:
            return MaterialPageRoute(
              builder: (context) => const SplashScreen(),
            );
        }
      },
    );
  }
}
