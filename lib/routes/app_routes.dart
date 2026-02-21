/// App route names for navigation
class AppRoutes {
  AppRoutes._();

  // Auth Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String roleSelection = '/role-selection';

  // Student Routes
  static const String studentDashboard = '/student-dashboard';
  static const String courseDiscovery = '/course-discovery';
  static const String courseDetail = '/course-detail';
  static const String myLearning = '/my-learning';
  static const String liveClass = '/live-class';
  static const String categoryCourses = '/category-courses';

  // Teacher Routes
  static const String teacherDashboard = '/teacher-dashboard';
  static const String courseManagement = '/course-management';
  static const String createCourse = '/create-course';
  static const String editCourse = '/edit-course';
  static const String studentManagement = '/student-management';
  static const String earnings = '/earnings';
  static const String schedule = '/schedule';

  // Chat Routes
  static const String chatList = '/chat-list';
  static const String chatDetail = '/chat-detail';

  // Profile Routes
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  // Subscription Routes
  static const String subscriptionPlans = '/subscription-plans';
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment-success';
}
