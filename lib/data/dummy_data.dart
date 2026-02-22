import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/teacher_model.dart';
import '../models/live_class_model.dart';

/// Dummy data for UI development and testing
class DummyData {
  DummyData._();

  /// Sample students
  static List<UserModel> get students => [
        const UserModel(
          id: 'student-1',
          name: 'John Doe',
          email: 'john.doe@email.com',
          username: 'johndoe',
          phone: '+1234567890',
          bio: 'Passionate learner interested in technology and science.',
          role: UserRole.student,
          isVerified: true,
          isOnline: true,
        ),
        const UserModel(
          id: 'student-2',
          name: 'Jane Smith',
          email: 'jane.smith@email.com',
          username: 'janesmith',
          bio: 'Art enthusiast and creative thinker.',
          role: UserRole.student,
          isVerified: true,
          isOnline: false,
        ),
      ];

  /// Sample teachers
  static List<TeacherModel> get teachers => [
        TeacherModel(
          id: 'teacher-1',
          user: const UserModel(
            id: 'user-teacher-1',
            name: 'Dr. Sarah Johnson',
            email: 'sarah.johnson@email.com',
            bio: 'Mathematics professor with 15+ years of teaching experience.',
            role: UserRole.teacher,
            isVerified: true,
            isOnline: true,
          ),
          expertise: ['Mathematics', 'Calculus', 'Statistics'],
          education: 'Ph.D. in Mathematics, MIT',
          experience: '15+ years teaching at university level',
          hourlyRate: 50.0,
          totalStudents: 1250,
          totalCourses: 12,
          totalReviews: 856,
          rating: 4.9,
          subscriberCount: 3200,
        ),
        TeacherModel(
          id: 'teacher-2',
          user: const UserModel(
            id: 'user-teacher-2',
            name: 'Michael Chen',
            email: 'michael.chen@email.com',
            bio: 'Full-stack developer and coding instructor.',
            role: UserRole.teacher,
            isVerified: true,
            isOnline: true,
          ),
          expertise: ['Programming', 'Web Development', 'Mobile Apps'],
          education: 'M.S. Computer Science, Stanford',
          experience: '10+ years in software development',
          hourlyRate: 45.0,
          totalStudents: 2100,
          totalCourses: 8,
          totalReviews: 1423,
          rating: 4.8,
          subscriberCount: 5100,
        ),
        TeacherModel(
          id: 'teacher-3',
          user: const UserModel(
            id: 'user-teacher-3',
            name: 'Emily Rodriguez',
            email: 'emily.rodriguez@email.com',
            bio: 'Language expert specializing in English and Spanish.',
            role: UserRole.teacher,
            isVerified: true,
            isOnline: false,
          ),
          expertise: ['English', 'Spanish', 'Language Arts'],
          education: 'M.A. in Linguistics, UCLA',
          experience: '8+ years teaching languages',
          hourlyRate: 35.0,
          totalStudents: 890,
          totalCourses: 6,
          totalReviews: 567,
          rating: 4.7,
          subscriberCount: 2100,
        ),
        TeacherModel(
          id: 'teacher-4',
          user: const UserModel(
            id: 'user-teacher-4',
            name: 'David Kim',
            email: 'david.kim@email.com',
            bio: 'Music producer and guitar instructor.',
            role: UserRole.teacher,
            isVerified: true,
            isOnline: true,
          ),
          expertise: ['Guitar', 'Music Production', 'Music Theory'],
          education: 'Berklee College of Music',
          experience: '12+ years in music industry',
          hourlyRate: 40.0,
          totalStudents: 650,
          totalCourses: 5,
          totalReviews: 423,
          rating: 4.9,
          subscriberCount: 1800,
        ),
      ];

  /// Sample courses
  static List<CourseModel> get courses => [
        CourseModel(
          id: 'course-1',
          title: 'Complete Mathematics Masterclass',
          description:
              'Master mathematics from basics to advanced calculus. This comprehensive course covers algebra, geometry, trigonometry, and calculus with practical examples and exercises.',
          teacherId: 'teacher-1',
          teacher: teachers[0].user,
          category: CourseCategory.math,
          level: CourseLevel.intermediate,
          price: 49.99,
          rating: 4.9,
          totalRatings: 456,
          totalStudents: 1250,
          totalLessons: 48,
          totalDuration: 2400,
          whatYouWillLearn: [
            'Master algebraic concepts and equations',
            'Understand geometric principles and proofs',
            'Apply calculus to real-world problems',
            'Solve complex mathematical problems with confidence',
          ],
          requirements: [
            'Basic understanding of arithmetic',
            'Willingness to practice and solve problems',
          ],
          sections: [
            CourseSection(
              id: 'section-1',
              title: 'Introduction to Algebra',
              order: 0,
              lessons: [
                const LessonModel(
                  id: 'lesson-1-1',
                  title: 'What is Algebra?',
                  duration: 15,
                  isPreview: true,
                  order: 0,
                ),
                const LessonModel(
                  id: 'lesson-1-2',
                  title: 'Variables and Constants',
                  duration: 20,
                  order: 1,
                ),
                const LessonModel(
                  id: 'lesson-1-3',
                  title: 'Solving Linear Equations',
                  duration: 25,
                  order: 2,
                ),
              ],
            ),
            CourseSection(
              id: 'section-2',
              title: 'Geometry Fundamentals',
              order: 1,
              lessons: [
                const LessonModel(
                  id: 'lesson-2-1',
                  title: 'Points, Lines, and Planes',
                  duration: 18,
                  order: 0,
                ),
                const LessonModel(
                  id: 'lesson-2-2',
                  title: 'Angles and Triangles',
                  duration: 22,
                  order: 1,
                ),
              ],
            ),
          ],
        ),
        CourseModel(
          id: 'course-2',
          title: 'Web Development Bootcamp',
          description:
              'Learn to build modern web applications from scratch. Cover HTML, CSS, JavaScript, React, and Node.js in this comprehensive bootcamp.',
          teacherId: 'teacher-2',
          teacher: teachers[1].user,
          category: CourseCategory.coding,
          level: CourseLevel.beginner,
          price: 79.99,
          rating: 4.8,
          totalRatings: 892,
          totalStudents: 2100,
          totalLessons: 65,
          totalDuration: 3600,
          whatYouWillLearn: [
            'Build responsive websites with HTML & CSS',
            'Create interactive web apps with JavaScript',
            'Develop single-page applications with React',
            'Build backend APIs with Node.js',
          ],
          requirements: [
            'No prior coding experience required',
            'A computer with internet access',
          ],
          sections: [
            CourseSection(
              id: 'section-1',
              title: 'HTML Fundamentals',
              order: 0,
              lessons: [
                const LessonModel(
                  id: 'lesson-1-1',
                  title: 'Introduction to HTML',
                  duration: 20,
                  isPreview: true,
                  order: 0,
                ),
                const LessonModel(
                  id: 'lesson-1-2',
                  title: 'HTML Elements and Tags',
                  duration: 25,
                  order: 1,
                ),
              ],
            ),
          ],
        ),
        CourseModel(
          id: 'course-3',
          title: 'Spanish for Beginners',
          description:
              'Start your journey to fluency in Spanish. Learn essential vocabulary, grammar, and conversation skills for everyday situations.',
          teacherId: 'teacher-3',
          teacher: teachers[2].user,
          category: CourseCategory.language,
          level: CourseLevel.beginner,
          price: 29.99,
          rating: 4.7,
          totalRatings: 324,
          totalStudents: 890,
          totalLessons: 36,
          totalDuration: 1800,
          whatYouWillLearn: [
            'Hold basic conversations in Spanish',
            'Understand essential grammar rules',
            'Build a vocabulary of 1000+ words',
            'Navigate real-world situations in Spanish',
          ],
          requirements: [
            'No prior Spanish knowledge required',
            'Commitment to practice daily',
          ],
          sections: [],
        ),
        CourseModel(
          id: 'course-4',
          title: 'Guitar Mastery: From Zero to Hero',
          description:
              'Learn guitar from scratch or improve your skills. Cover chords, strumming patterns, fingerpicking, and music theory.',
          teacherId: 'teacher-4',
          teacher: teachers[3].user,
          category: CourseCategory.music,
          level: CourseLevel.beginner,
          price: 39.99,
          rating: 4.9,
          totalRatings: 267,
          totalStudents: 650,
          totalLessons: 42,
          totalDuration: 2100,
          whatYouWillLearn: [
            'Play popular songs on guitar',
            'Master essential chords and transitions',
            'Develop fingerpicking techniques',
            'Understand music theory basics',
          ],
          requirements: [
            'A guitar (acoustic or electric)',
            'No prior experience needed',
          ],
          sections: [],
        ),
        CourseModel(
          id: 'course-5',
          title: 'Advanced Calculus & Analysis',
          description:
              'Deep dive into advanced calculus topics including multivariable calculus, differential equations, and real analysis.',
          teacherId: 'teacher-1',
          teacher: teachers[0].user,
          category: CourseCategory.math,
          level: CourseLevel.advanced,
          price: 69.99,
          rating: 4.8,
          totalRatings: 189,
          totalStudents: 450,
          totalLessons: 52,
          totalDuration: 3000,
          whatYouWillLearn: [
            'Solve multivariable calculus problems',
            'Understand differential equations',
            'Apply real analysis concepts',
            'Prepare for advanced mathematics courses',
          ],
          requirements: [
            'Strong foundation in single-variable calculus',
            'Familiarity with basic proofs',
          ],
          sections: [],
        ),
        CourseModel(
          id: 'course-6',
          title: 'Mobile App Development with Flutter',
          description:
              'Build beautiful, natively compiled applications for mobile from a single codebase using Flutter and Dart.',
          teacherId: 'teacher-2',
          teacher: teachers[1].user,
          category: CourseCategory.coding,
          level: CourseLevel.intermediate,
          price: 59.99,
          rating: 4.7,
          totalRatings: 456,
          totalStudents: 1200,
          totalLessons: 55,
          totalDuration: 2700,
          whatYouWillLearn: [
            'Build cross-platform mobile apps',
            'Master Flutter widgets and layouts',
            'Implement state management',
            'Publish apps to app stores',
          ],
          requirements: [
            'Basic programming knowledge',
            'Familiarity with any programming language',
          ],
          sections: [],
        ),
      ];

  /// Sample live classes
  static List<LiveClassModel> get liveClasses => [
        LiveClassModel(
          id: 'live-1',
          title: 'Live Q&A: Calculus Problem Solving',
          description:
              'Join this interactive session to solve calculus problems and get your questions answered.',
          teacherId: 'teacher-1',
          teacher: teachers[0].user,
          courseId: 'course-1',
          course: courses[0],
          scheduledAt: DateTime.now().add(const Duration(hours: 2)),
          duration: 60,
          status: LiveClassStatus.scheduled,
          viewerCount: 0,
          maxParticipants: 50,
        ),
        LiveClassModel(
          id: 'live-2',
          title: 'Live Coding: Building a React App',
          description:
              'Watch and learn as we build a complete React application from scratch.',
          teacherId: 'teacher-2',
          teacher: teachers[1].user,
          courseId: 'course-2',
          course: courses[1],
          scheduledAt: DateTime.now().subtract(const Duration(minutes: 30)),
          duration: 90,
          status: LiveClassStatus.live,
          viewerCount: 156,
          maxParticipants: 100,
        ),
        LiveClassModel(
          id: 'live-3',
          title: 'Spanish Conversation Practice',
          description:
              'Practice your Spanish speaking skills in this interactive conversation session.',
          teacherId: 'teacher-3',
          teacher: teachers[2].user,
          courseId: 'course-3',
          course: courses[2],
          scheduledAt: DateTime.now().add(const Duration(days: 1)),
          duration: 45,
          status: LiveClassStatus.scheduled,
          viewerCount: 0,
          maxParticipants: 20,
        ),
        LiveClassModel(
          id: 'live-4',
          title: 'Guitar Workshop: Learn Your First Song',
          description:
              'Learn to play a popular song step-by-step in this beginner-friendly workshop.',
          teacherId: 'teacher-4',
          teacher: teachers[3].user,
          courseId: 'course-4',
          course: courses[3],
          scheduledAt: DateTime.now().add(const Duration(days: 2)),
          duration: 60,
          status: LiveClassStatus.scheduled,
          viewerCount: 0,
          maxParticipants: 30,
        ),
      ];

  /// Get enrolled courses for a student
  static List<CourseModel> getEnrolledCourses(String studentId) {
    return [
      courses[0].copyWith(isEnrolled: true, progress: 0.65),
      courses[1].copyWith(isEnrolled: true, progress: 0.30),
      courses[3].copyWith(isEnrolled: true, progress: 0.85),
    ];
  }

  /// Get courses by category
  static List<CourseModel> getCoursesByCategory(CourseCategory category) {
    return courses.where((course) => course.category == category).toList();
  }

  /// Get courses by teacher
  static List<CourseModel> getCoursesByTeacher(String teacherId) {
    return courses.where((course) => course.teacherId == teacherId).toList();
  }

  /// Get featured teachers
  static List<TeacherModel> getFeaturedTeachers() {
    return teachers..sort((a, b) => b.rating.compareTo(a.rating));
  }

  /// Get popular courses
  static List<CourseModel> getPopularCourses() {
    return courses..sort((a, b) => b.totalStudents.compareTo(a.totalStudents));
  }

  /// Get live classes now
  static List<LiveClassModel> getLiveClassesNow() {
    return liveClasses.where((lc) => lc.status == LiveClassStatus.live).toList();
  }

  /// Get upcoming live classes
  static List<LiveClassModel> getUpcomingLiveClasses() {
    return liveClasses
        .where((lc) => lc.status == LiveClassStatus.scheduled)
        .toList()
      ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }
}
