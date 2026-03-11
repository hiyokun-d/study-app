import 'user_model.dart';
import 'course_model.dart';

/// Live class model for scheduled live sessions
class LiveClassModel {
  const LiveClassModel({
    required this.id,
    required this.title,
    required this.description,
    required this.teacherId,
    this.teacher,
    required this.courseId,
    this.course,
    required this.scheduledAt,
    required this.duration,
    this.status = LiveClassStatus.scheduled,
    this.thumbnail,
    this.viewerCount = 0,
    this.maxParticipants = 100,
    this.isSubscribed = false,
    this.meetingUrl,
  });

  final String id;
  final String title;
  final String description;
  final String teacherId;
  final UserModel? teacher;
  final String courseId;
  final CourseModel? course;
  final DateTime scheduledAt;
  final int duration; // in minutes
  final LiveClassStatus status;
  final String? thumbnail;
  final int viewerCount;
  final int maxParticipants;
  final bool isSubscribed;
  final String? meetingUrl;

  /// Get formatted duration string
  String get formattedDuration {
    if (duration < 60) {
      return '$duration min';
    }
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (minutes == 0) {
      return '$hours hr';
    }
    return '$hours hr $minutes min';
  }

  /// Get formatted scheduled time
  String get formattedTime {
    final hour = scheduledAt.hour.toString().padLeft(2, '0');
    final minute = scheduledAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Get formatted scheduled date
  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${scheduledAt.day} ${months[scheduledAt.month - 1]} ${scheduledAt.year}';
  }

  /// Check if class is starting soon (within 5 minutes)
  bool get isStartingSoon {
    final now = DateTime.now();
    final difference = scheduledAt.difference(now);
    return difference.inMinutes <= 5 && difference.inMinutes >= 0;
  }

  /// Check if class can be joined
  bool get canJoin {
    return status == LiveClassStatus.live || isStartingSoon;
  }

  /// Copy with new values
  LiveClassModel copyWith({
    String? id,
    String? title,
    String? description,
    String? teacherId,
    UserModel? teacher,
    String? courseId,
    CourseModel? course,
    DateTime? scheduledAt,
    int? duration,
    LiveClassStatus? status,
    String? thumbnail,
    int? viewerCount,
    int? maxParticipants,
    bool? isSubscribed,
    String? meetingUrl,
  }) {
    return LiveClassModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      teacherId: teacherId ?? this.teacherId,
      teacher: teacher ?? this.teacher,
      courseId: courseId ?? this.courseId,
      course: course ?? this.course,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      thumbnail: thumbnail ?? this.thumbnail,
      viewerCount: viewerCount ?? this.viewerCount,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      isSubscribed: isSubscribed ?? this.isSubscribed,
      meetingUrl: meetingUrl ?? this.meetingUrl,
    );
  }
}

/// Live class status enum
enum LiveClassStatus {
  scheduled,
  live,
  ended,
  cancelled,
}

/// Extension for LiveClassStatus
extension LiveClassStatusExtension on LiveClassStatus {
  String get displayName {
    switch (this) {
      case LiveClassStatus.scheduled:
        return 'Scheduled';
      case LiveClassStatus.live:
        return 'Live';
      case LiveClassStatus.ended:
        return 'Ended';
      case LiveClassStatus.cancelled:
        return 'Cancelled';
    }
  }
}
