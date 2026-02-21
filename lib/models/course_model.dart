import 'user_model.dart';

/// Course model representing a course created by a teacher
class CourseModel {
  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.teacherId,
    this.teacher,
    required this.category,
    required this.level,
    required this.price,
    this.thumbnail,
    this.rating = 0.0,
    this.totalRatings = 0,
    this.totalStudents = 0,
    this.totalLessons = 0,
    this.totalDuration = 0,
    this.sections = const [],
    this.whatYouWillLearn = const [],
    this.requirements = const [],
    this.status = CourseStatus.published,
    this.createdAt,
    this.updatedAt,
    this.isEnrolled = false,
    this.progress = 0.0,
  });

  final String id;
  final String title;
  final String description;
  final String teacherId;
  final UserModel? teacher;
  final CourseCategory category;
  final CourseLevel level;
  final double price;
  final String? thumbnail;
  final double rating;
  final int totalRatings;
  final int totalStudents;
  final int totalLessons;
  final int totalDuration; // in minutes
  final List<CourseSection> sections;
  final List<String> whatYouWillLearn;
  final List<String> requirements;
  final CourseStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isEnrolled;
  final double progress; // 0.0 to 1.0

  /// Get formatted duration string
  String get formattedDuration {
    if (totalDuration < 60) {
      return '$totalDuration min';
    }
    final hours = totalDuration ~/ 60;
    final minutes = totalDuration % 60;
    if (minutes == 0) {
      return '$hours hr';
    }
    return '$hours hr $minutes min';
  }

  /// Get formatted price string
  String get formattedPrice {
    if (price == 0) {
      return 'Free';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Copy with new values
  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? teacherId,
    UserModel? teacher,
    CourseCategory? category,
    CourseLevel? level,
    double? price,
    String? thumbnail,
    double? rating,
    int? totalRatings,
    int? totalStudents,
    int? totalLessons,
    int? totalDuration,
    List<CourseSection>? sections,
    List<String>? whatYouWillLearn,
    List<String>? requirements,
    CourseStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEnrolled,
    double? progress,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      teacherId: teacherId ?? this.teacherId,
      teacher: teacher ?? this.teacher,
      category: category ?? this.category,
      level: level ?? this.level,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      totalStudents: totalStudents ?? this.totalStudents,
      totalLessons: totalLessons ?? this.totalLessons,
      totalDuration: totalDuration ?? this.totalDuration,
      sections: sections ?? this.sections,
      whatYouWillLearn: whatYouWillLearn ?? this.whatYouWillLearn,
      requirements: requirements ?? this.requirements,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      progress: progress ?? this.progress,
    );
  }
}

/// Course section model
class CourseSection {
  const CourseSection({
    required this.id,
    required this.title,
    required this.lessons,
    this.order = 0,
  });

  final String id;
  final String title;
  final List<LessonModel> lessons;
  final int order;
}

/// Lesson model
class LessonModel {
  const LessonModel({
    required this.id,
    required this.title,
    required this.duration,
    this.videoUrl,
    this.description,
    this.isPreview = false,
    this.isCompleted = false,
    this.order = 0,
  });

  final String id;
  final String title;
  final int duration; // in minutes
  final String? videoUrl;
  final String? description;
  final bool isPreview;
  final bool isCompleted;
  final int order;

  /// Get formatted duration string
  String get formattedDuration {
    return '$duration min';
  }
}

/// Course category enum
enum CourseCategory {
  math,
  science,
  language,
  arts,
  music,
  coding,
  business,
  other,
}

/// Extension for CourseCategory
extension CourseCategoryExtension on CourseCategory {
  String get displayName {
    switch (this) {
      case CourseCategory.math:
        return 'Mathematics';
      case CourseCategory.science:
        return 'Science';
      case CourseCategory.language:
        return 'Language';
      case CourseCategory.arts:
        return 'Arts';
      case CourseCategory.music:
        return 'Music';
      case CourseCategory.coding:
        return 'Coding';
      case CourseCategory.business:
        return 'Business';
      case CourseCategory.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case CourseCategory.math:
        return 'calculate';
      case CourseCategory.science:
        return 'science';
      case CourseCategory.language:
        return 'translate';
      case CourseCategory.arts:
        return 'palette';
      case CourseCategory.music:
        return 'music_note';
      case CourseCategory.coding:
        return 'code';
      case CourseCategory.business:
        return 'business';
      case CourseCategory.other:
        return 'category';
    }
  }
}

/// Course level enum
enum CourseLevel {
  beginner,
  intermediate,
  advanced,
}

/// Extension for CourseLevel
extension CourseLevelExtension on CourseLevel {
  String get displayName {
    switch (this) {
      case CourseLevel.beginner:
        return 'Beginner';
      case CourseLevel.intermediate:
        return 'Intermediate';
      case CourseLevel.advanced:
        return 'Advanced';
    }
  }
}

/// Course status enum
enum CourseStatus {
  draft,
  published,
  archived,
}

/// Extension for CourseStatus
extension CourseStatusExtension on CourseStatus {
  String get displayName {
    switch (this) {
      case CourseStatus.draft:
        return 'Draft';
      case CourseStatus.published:
        return 'Published';
      case CourseStatus.archived:
        return 'Archived';
    }
  }
}
