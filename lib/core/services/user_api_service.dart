import 'dart:convert';

import '../constants/app_config.dart';
import '../network/api_client.dart';
import '../../data/dummy_data.dart';
import '../../models/booking_model.dart';
import '../../models/tutor_profile.dart';
import 'auth_state.dart';
import '../../models/chat_models.dart';
// Re-export chat models so existing import paths continue to work.
export '../../models/chat_models.dart';

class UserApiService {
  UserApiService._();
  static final UserApiService instance = UserApiService._();

  // ─── Update Profile ───────────────────────────────────────────────────────

  Future<UpdateProfileResult> updateProfile({
    String? username,
    String? fullName,
    String? bio,
    String? avatarUrl,
    String? role,
  }) async {
    if (!AuthState.instance.isLoggedIn) {
      return UpdateProfileResult.error('Not authenticated. Please log in first.');
    }

    final body = <String, dynamic>{};
    if (username != null) body['username'] = username;
    if (fullName != null) body['full_name'] = fullName;
    if (bio != null) body['bio'] = bio;
    if (avatarUrl != null) body['avatar_url'] = avatarUrl;
    if (role != null) body['role'] = role;

    try {
      final response = await ApiClient.instance.patch(
        '/user/update/profile',
        body,
        requiresAuth: true,
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UpdateProfileResult.success(data['user'] as Map<String, dynamic>);
      }

      final message = data['message']?.toString() ?? 'Update failed (${response.statusCode})';
      return UpdateProfileResult.error(message);
    } on StateError catch (e) {
      return UpdateProfileResult.error(e.message);
    } catch (e) {
      return UpdateProfileResult.error(ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Get Tutors ───────────────────────────────────────────────────────────

  Future<TutorListResult> getTutors({
    String? search,
    String? subject,
    double? maxPrice,
  }) async {
    if (AppConfig.useMock) {
      await Future.delayed(const Duration(milliseconds: 700));
      final mockTutors = DummyData.teachers.map((t) => TutorProfile(
            id: t.id,
            fullName: t.user.name,
            subjects: t.expertise,
            bookPrice: t.hourlyRate ?? 0,
            overallRating: t.rating,
            ratingCount: t.totalReviews,
            avatarUrl: null,
          )).toList();
      return TutorListResult.success(mockTutors);
    }

    final queryParams = <String, String>{};
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (subject != null && subject.isNotEmpty) queryParams['subject'] = subject;
    if (maxPrice != null) queryParams['maxCoins'] = maxPrice.toString();

    try {
      final response = await ApiClient.instance.get(
        '/user/tutors',
        queryParams: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return TutorListResult.success(
          list.map((e) => TutorProfile.fromJson(e as Map<String, dynamic>)).toList(),
        );
      }

      return TutorListResult.error('Failed to load tutors (${response.statusCode})');
    } on StateError catch (e) {
      return TutorListResult.error(e.message);
    } catch (e) {
      return TutorListResult.error(ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Get Tutor Detail ─────────────────────────────────────────────────────

  Future<TutorDetailResult> getTutorDetail(String tutorId) async {
    try {
      final response = await ApiClient.instance.get('/user/tutor/$tutorId');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return TutorDetailResult.success(data);
      }

      return TutorDetailResult.error('Failed to load tutor (${response.statusCode})');
    } on StateError catch (e) {
      return TutorDetailResult.error(e.message);
    } catch (e) {
      return TutorDetailResult.error(ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Get Student Bookings ─────────────────────────────────────────────────

  Future<BookingListResult> getStudentBookings({
    String? status,
    String? from,
    String? to,
  }) async {
    if (!AuthState.instance.isLoggedIn) {
      return BookingListResult.error('Not authenticated.');
    }

    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (from != null) queryParams['from'] = from;
    if (to != null) queryParams['to'] = to;

    try {
      final response = await ApiClient.instance.get(
        '/booking/student',
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return BookingListResult.success(
          list.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList(),
        );
      }

      return BookingListResult.error('Failed to load bookings (${response.statusCode})');
    } on StateError catch (e) {
      return BookingListResult.error(e.message);
    } catch (e) {
      return BookingListResult.error(ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Get Join Info (Jitsi) ────────────────────────────────────────────────

  Future<JoinInfoResult> getJoinInfo(String bookingId) async {
    if (!AuthState.instance.isLoggedIn) {
      return JoinInfoResult.error('Not authenticated.');
    }

    try {
      final response = await ApiClient.instance.get(
        '/booking/$bookingId/join',
        requiresAuth: true,
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return JoinInfoResult.success(
          meetingUrl: data['meeting_url'].toString(),
          roomPassword: data['room_password']?.toString(),
        );
      }

      final msg = data['message']?.toString() ?? 'Cannot join (${response.statusCode})';
      return JoinInfoResult.error(msg);
    } on StateError catch (e) {
      return JoinInfoResult.error(e.message);
    } catch (e) {
      return JoinInfoResult.error(ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Get Chat Thread List ─────────────────────────────────────────────────

  Future<ChatThreadListResult> getChatThreadList() async {
    if (!AuthState.instance.isLoggedIn) {
      return ChatThreadListResult.error('Not authenticated.');
    }

    try {
      final response = await ApiClient.instance.get(
        '/messages/conversations',
        requiresAuth: true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data is List) {
          final list = data.whereType<Map<String, dynamic>>().toList();
          return ChatThreadListResult.success(
            list.map((e) => ChatThread.fromJson(e)).toList(),
          );
        }
        return ChatThreadListResult.success([]);
      }

      return ChatThreadListResult.error('Failed to load chats (${response.statusCode})');
    } on StateError catch (e) {
      return ChatThreadListResult.error(e.message);
    } catch (e) {
      return ChatThreadListResult.error(ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Get Chat Thread ──────────────────────────────────────────────────────

  Future<ChatMessageListResult> getChatThread(String otherId) async {
    if (!AuthState.instance.isLoggedIn) {
      return ChatMessageListResult.error('Not authenticated.');
    }

    try {
      final response = await ApiClient.instance.get(
        '/messages/conversation/$otherId',
        requiresAuth: true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final messagesData = data['messages'];
        if (messagesData is List) {
          final messagesList = messagesData.whereType<Map<String, dynamic>>().toList();
          return ChatMessageListResult.success(
            messagesList.map((e) => ChatMessage.fromJson(e)).toList(),
          );
        }
        return ChatMessageListResult.success([]);
      }

      return ChatMessageListResult.error('Failed to load messages (${response.statusCode})');
    } on StateError catch (e) {
      return ChatMessageListResult.error(e.message);
    } catch (e) {
      return ChatMessageListResult.error(ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Mark Thread as Read ──────────────────────────────────────────────────

  Future<SimpleResult> markAllMessagesAsRead(String otherId) async {
    try {
      final response = await ApiClient.instance.patch(
        '/messages/conversation/$otherId/read-all',
        {},
        requiresAuth: true,
      );
      return SimpleResult(
        success: response.statusCode == 200,
        message: jsonDecode(response.body)['message']?.toString(),
      );
    } catch (_) {
      return SimpleResult(success: false);
    }
  }

  // ─── Send Message ─────────────────────────────────────────────────────────

  Future<SendMessageResult> sendMessage({
    required String toId,
    required String content,
    String? bookingId,
  }) async {
    if (!AuthState.instance.isLoggedIn) {
      return SendMessageResult.error('Not authenticated.');
    }

    final trimmed = content.trim();
    if (trimmed.isEmpty) return SendMessageResult.error('Message cannot be empty.');
    if (trimmed.length > AppConfig.maxMessageLength) {
      return SendMessageResult.error(
          'Message too long. Maximum ${AppConfig.maxMessageLength} characters.');
    }

    final body = <String, dynamic>{
      'to_id': toId,
      'content': trimmed,
      if (bookingId != null) 'booking_id': bookingId,
    };

    try {
      final response = await ApiClient.instance.post(
        '/messages',
        body,
        requiresAuth: true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data is Map<String, dynamic>) {
          return SendMessageResult.success(ChatMessage.fromJson(data));
        }
      }

      return SendMessageResult.error(
          data['message']?.toString() ?? 'Failed to send (${response.statusCode})');
    } on StateError catch (e) {
      return SendMessageResult.error(e.message);
    } catch (e) {
      return SendMessageResult.error(ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Booking Actions ──────────────────────────────────────────────────────

  Future<SimpleResult> cancelBooking(String bookingId) async {
    try {
      final response = await ApiClient.instance.patch(
        '/booking/$bookingId/cancel',
        {},
        requiresAuth: true,
      );
      return SimpleResult(
        success: response.statusCode == 200,
        message: jsonDecode(response.body)['message']?.toString(),
      );
    } on StateError catch (e) {
      return SimpleResult(success: false, message: e.message);
    } catch (e) {
      return SimpleResult(success: false, message: ApiClient.instance.friendlyError(e));
    }
  }

  Future<SimpleResult> proposeReschedule(
    String bookingId,
    DateTime newStart,
    DateTime newEnd, {
    String? reason,
  }) async {
    try {
      final body = <String, dynamic>{
        'new_start_at': newStart.toIso8601String(),
        'new_end_at': newEnd.toIso8601String(),
        if (reason != null && reason.isNotEmpty) 'reason': reason,
      };
      final response = await ApiClient.instance.patch(
        '/booking/$bookingId/propose-reschedule',
        body,
        requiresAuth: true,
      );
      return SimpleResult(
        success: response.statusCode == 200,
        message: jsonDecode(response.body)['message']?.toString(),
      );
    } on StateError catch (e) {
      return SimpleResult(success: false, message: e.message);
    } catch (e) {
      return SimpleResult(success: false, message: ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Student reschedule responses ─────────────────────────────────────────

  Future<SimpleResult> acceptReschedule(String bookingId) async {
    try {
      final response = await ApiClient.instance.patch(
        '/booking/$bookingId/accept-reschedule',
        {},
        requiresAuth: true,
      );
      return SimpleResult(
        success: response.statusCode == 200,
        message: jsonDecode(response.body)['message']?.toString(),
      );
    } on StateError catch (e) {
      return SimpleResult(success: false, message: e.message);
    } catch (e) {
      return SimpleResult(success: false, message: ApiClient.instance.friendlyError(e));
    }
  }

  Future<SimpleResult> rejectReschedule(String bookingId) async {
    try {
      final response = await ApiClient.instance.patch(
        '/booking/$bookingId/reject-reschedule',
        {},
        requiresAuth: true,
      );
      return SimpleResult(
        success: response.statusCode == 200,
        message: jsonDecode(response.body)['message']?.toString(),
      );
    } on StateError catch (e) {
      return SimpleResult(success: false, message: e.message);
    } catch (e) {
      return SimpleResult(success: false, message: ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Student price responses ───────────────────────────────────────────────

  Future<SimpleResult> acceptPrice(String bookingId) async {
    try {
      final response = await ApiClient.instance.patch(
        '/booking/$bookingId/accept-price',
        {},
        requiresAuth: true,
      );
      return SimpleResult(
        success: response.statusCode == 200,
        message: jsonDecode(response.body)['message']?.toString(),
      );
    } on StateError catch (e) {
      return SimpleResult(success: false, message: e.message);
    } catch (e) {
      return SimpleResult(success: false, message: ApiClient.instance.friendlyError(e));
    }
  }

  Future<SimpleResult> rejectPrice(String bookingId) async {
    try {
      final response = await ApiClient.instance.patch(
        '/booking/$bookingId/reject-price',
        {},
        requiresAuth: true,
      );
      return SimpleResult(
        success: response.statusCode == 200,
        message: jsonDecode(response.body)['message']?.toString(),
      );
    } on StateError catch (e) {
      return SimpleResult(success: false, message: e.message);
    } catch (e) {
      return SimpleResult(success: false, message: ApiClient.instance.friendlyError(e));
    }
  }

  // ─── User presence ─────────────────────────────────────────────────────────

  /// [status]: 'ONLINE' | 'OFFLINE' | 'BUSY'
  Future<SimpleResult> updateStatus(String status) async {
    if (!AuthState.instance.isLoggedIn) {
      return SimpleResult(success: false, message: 'Not authenticated.');
    }
    try {
      final response = await ApiClient.instance.patch(
        '/user/status',
        {'status': status},
        requiresAuth: true,
      );
      return SimpleResult(
        success: response.statusCode == 200,
        message: jsonDecode(response.body)['message']?.toString(),
      );
    } on StateError catch (e) {
      return SimpleResult(success: false, message: e.message);
    } catch (e) {
      return SimpleResult(success: false, message: ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Reviews ───────────────────────────────────────────────────────────────

  Future<ReviewListResult> getTutorReviews(String tutorId) async {
    try {
      final response = await ApiClient.instance.get('/reviews/tutor/$tutorId');
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return ReviewListResult.success(list.cast<Map<String, dynamic>>());
      }
      return ReviewListResult.error('Failed to load reviews (${response.statusCode})');
    } on StateError catch (e) {
      return ReviewListResult.error(e.message);
    } catch (e) {
      return ReviewListResult.error(ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Public offers ─────────────────────────────────────────────────────────

  Future<OfferListResult> getPublicOffers() async {
    try {
      final response = await ApiClient.instance.get('/offers');
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return OfferListResult.success(list.cast<Map<String, dynamic>>());
      }
      return OfferListResult.error('Failed to load offers (${response.statusCode})');
    } on StateError catch (e) {
      return OfferListResult.error(e.message);
    } catch (e) {
      return OfferListResult.error(ApiClient.instance.friendlyError(e));
    }
  }

  Future<OfferDetailResult> getOfferById(String offerId) async {
    try {
      final response = await ApiClient.instance.get('/offers/$offerId');
      if (response.statusCode == 200) {
        return OfferDetailResult.success(jsonDecode(response.body) as Map<String, dynamic>);
      }
      return OfferDetailResult.error('Failed to load offer (${response.statusCode})');
    } on StateError catch (e) {
      return OfferDetailResult.error(e.message);
    } catch (e) {
      return OfferDetailResult.error(ApiClient.instance.friendlyError(e));
    }
  }

  // ─── All students ──────────────────────────────────────────────────────────

  Future<StudentListResult> getAllStudents() async {
    if (!AuthState.instance.isLoggedIn) {
      return StudentListResult.error('Not authenticated.');
    }
    try {
      final response = await ApiClient.instance.get(
        '/user/student',
        requiresAuth: true,
      );
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List;
        return StudentListResult.success(list.cast<Map<String, dynamic>>());
      }
      return StudentListResult.error('Failed to load students (${response.statusCode})');
    } on StateError catch (e) {
      return StudentListResult.error(e.message);
    } catch (e) {
      return StudentListResult.error(ApiClient.instance.friendlyError(e));
    }
  }

  // ─── Avatar Upload ────────────────────────────────────────────────────────

  Future<SimpleResult> updateAvatar(String imageUrl) async {
    return updateProfile(avatarUrl: imageUrl).then(
        (res) => SimpleResult(success: res.success, message: res.errorMessage));
  }
}

// ─── Result Models ────────────────────────────────────────────────────────────

class SimpleResult {
  final bool success;
  final String? message;
  SimpleResult({required this.success, this.message});
}

class UpdateProfileResult {
  final bool success;
  final Map<String, dynamic>? user;
  final String? errorMessage;

  const UpdateProfileResult._({required this.success, this.user, this.errorMessage});

  factory UpdateProfileResult.success(Map<String, dynamic> user) =>
      UpdateProfileResult._(success: true, user: user);

  factory UpdateProfileResult.error(String message) =>
      UpdateProfileResult._(success: false, errorMessage: message);
}

class TutorListResult {
  final bool success;
  final List<TutorProfile>? tutors;
  final String? errorMessage;

  const TutorListResult._({required this.success, this.tutors, this.errorMessage});

  factory TutorListResult.success(List<TutorProfile> tutors) =>
      TutorListResult._(success: true, tutors: tutors);

  factory TutorListResult.error(String message) =>
      TutorListResult._(success: false, errorMessage: message);
}

class TutorDetailResult {
  final bool success;
  final Map<String, dynamic>? tutor;
  final String? errorMessage;

  const TutorDetailResult._({required this.success, this.tutor, this.errorMessage});

  factory TutorDetailResult.success(Map<String, dynamic> tutor) =>
      TutorDetailResult._(success: true, tutor: tutor);

  factory TutorDetailResult.error(String message) =>
      TutorDetailResult._(success: false, errorMessage: message);
}

class BookingListResult {
  final bool success;
  final List<Booking>? bookings;
  final String? errorMessage;

  const BookingListResult._({required this.success, this.bookings, this.errorMessage});

  factory BookingListResult.success(List<Booking> bookings) =>
      BookingListResult._(success: true, bookings: bookings);

  factory BookingListResult.error(String message) =>
      BookingListResult._(success: false, errorMessage: message);
}

class JoinInfoResult {
  final bool success;
  final String? meetingUrl;
  final String? roomPassword;
  final String? errorMessage;

  const JoinInfoResult._({
    required this.success,
    this.meetingUrl,
    this.roomPassword,
    this.errorMessage,
  });

  factory JoinInfoResult.success({required String meetingUrl, String? roomPassword}) =>
      JoinInfoResult._(success: true, meetingUrl: meetingUrl, roomPassword: roomPassword);

  factory JoinInfoResult.error(String message) =>
      JoinInfoResult._(success: false, errorMessage: message);
}

class ChatThreadListResult {
  final bool success;
  final List<ChatThread>? threads;
  final String? errorMessage;

  const ChatThreadListResult._({required this.success, this.threads, this.errorMessage});

  factory ChatThreadListResult.success(List<ChatThread> threads) =>
      ChatThreadListResult._(success: true, threads: threads);

  factory ChatThreadListResult.error(String message) =>
      ChatThreadListResult._(success: false, errorMessage: message);
}

class ChatMessageListResult {
  final bool success;
  final List<ChatMessage>? messages;
  final String? errorMessage;

  const ChatMessageListResult._({required this.success, this.messages, this.errorMessage});

  factory ChatMessageListResult.success(List<ChatMessage> messages) =>
      ChatMessageListResult._(success: true, messages: messages);

  factory ChatMessageListResult.error(String message) =>
      ChatMessageListResult._(success: false, errorMessage: message);
}

class SendMessageResult {
  final bool success;
  final ChatMessage? message;
  final String? errorMessage;

  const SendMessageResult._({required this.success, this.message, this.errorMessage});

  factory SendMessageResult.success(ChatMessage message) =>
      SendMessageResult._(success: true, message: message);

  factory SendMessageResult.error(String message) =>
      SendMessageResult._(success: false, errorMessage: message);
}

class ReviewListResult {
  final bool success;
  final List<Map<String, dynamic>>? reviews;
  final String? errorMessage;

  const ReviewListResult._({required this.success, this.reviews, this.errorMessage});

  factory ReviewListResult.success(List<Map<String, dynamic>> reviews) =>
      ReviewListResult._(success: true, reviews: reviews);

  factory ReviewListResult.error(String message) =>
      ReviewListResult._(success: false, errorMessage: message);
}

class OfferListResult {
  final bool success;
  final List<Map<String, dynamic>>? offers;
  final String? errorMessage;

  const OfferListResult._({required this.success, this.offers, this.errorMessage});

  factory OfferListResult.success(List<Map<String, dynamic>> offers) =>
      OfferListResult._(success: true, offers: offers);

  factory OfferListResult.error(String message) =>
      OfferListResult._(success: false, errorMessage: message);
}

class OfferDetailResult {
  final bool success;
  final Map<String, dynamic>? offer;
  final String? errorMessage;

  const OfferDetailResult._({required this.success, this.offer, this.errorMessage});

  factory OfferDetailResult.success(Map<String, dynamic> offer) =>
      OfferDetailResult._(success: true, offer: offer);

  factory OfferDetailResult.error(String message) =>
      OfferDetailResult._(success: false, errorMessage: message);
}

class StudentListResult {
  final bool success;
  final List<Map<String, dynamic>>? students;
  final String? errorMessage;

  const StudentListResult._({required this.success, this.students, this.errorMessage});

  factory StudentListResult.success(List<Map<String, dynamic>> students) =>
      StudentListResult._(success: true, students: students);

  factory StudentListResult.error(String message) =>
      StudentListResult._(success: false, errorMessage: message);
}
