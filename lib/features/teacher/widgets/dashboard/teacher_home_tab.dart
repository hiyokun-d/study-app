import 'package:flutter/material.dart';
import '../../../../core/services/auth_state.dart';
import '../../../../core/services/booking_api_service.dart';

class TeacherHomeTab extends StatefulWidget {
  const TeacherHomeTab({super.key});

  @override
  State<TeacherHomeTab> createState() => _TeacherHomeTabState();
}

class _TeacherHomeTabState extends State<TeacherHomeTab> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _bookings = [];

  static const _activities = [
    {'type': 'enrollment', 'message': 'New booking received', 'time': 'Just now'},
    {'type': 'review', 'message': 'Check your latest reviews', 'time': 'Today'},
    {'type': 'message', 'message': 'You have new messages', 'time': 'Today'},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await BookingApiService.instance.getTutorBookings();
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (result.success) {
        _bookings = result.bookings ?? [];
      } else {
        _error = result.errorMessage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = AuthState.instance.displayName;
    final coinsBalance = AuthState.instance.coinsBalance;

    final stats = [
      {
        'title': 'Active Sessions',
        'value': '${_bookings.length}',
        'icon': Icons.menu_book_rounded,
        'color': const Color(0xFF10B981),
      },
      {
        'title': 'Coin Balance',
        'value': '$coinsBalance',
        'icon': Icons.account_balance_wallet_rounded,
        'color': const Color(0xFF6366F1),
      },
      {
        'title': 'Total Students',
        'value': '—',
        'icon': Icons.people_rounded,
        'color': const Color(0xFF3B82F6),
      },
      {
        'title': 'Average Rating',
        'value': '—',
        'icon': Icons.star_rounded,
        'color': const Color(0xFFF59E0B),
      },
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF3B82F6),
              Color(0xFF93C5FD),
              Color(0xFFFFFFFF),
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(name),
                  const SizedBox(height: 24),
                  _buildQuickStats(stats),
                  const SizedBox(height: 32),
                  _buildUpcomingSessions(),
                  const SizedBox(height: 32),
                  _buildRecentActivity(),
                  const SizedBox(height: 32),
                  _buildQuickActions(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning! 👋',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: AuthState.instance.avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          AuthState.instance.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.person_rounded, color: Colors.white, size: 32),
                        ),
                      )
                    : const Icon(Icons.person_rounded, color: Colors.white, size: 32),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF3B82F6), width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(List<Map<String, dynamic>> stats) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          final s = stats[index];
          return Container(
            width: 150,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (s['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 20),
                ),
                const Spacer(),
                Text(
                  s['value'] as String,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  s['title'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingSessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Sessions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          )
        else if (_bookings.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'No upcoming sessions.',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          )
        else
          ..._bookings.take(3).map(_buildBookingCard),
      ],
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = booking['status']?.toString() ?? '';
    final startAt = booking['start_at']?.toString() ?? '';
    final title = (booking['tutor_offer'] as Map<String, dynamic>?)?['title']?.toString() ??
        booking['description']?.toString() ??
        'Session';

    DateTime? parsedTime;
    try {
      parsedTime = DateTime.parse(startAt);
    } catch (_) {}
    final timeLabel = parsedTime != null
        ? '${parsedTime.hour}:${parsedTime.minute.toString().padLeft(2, '0')}'
        : startAt;

    return _buildSessionCard({
      'title': title,
      'time': timeLabel,
      'students': 1,
      'status': status,
    });
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    final isImmediate = session['status'] == 'PENDING';

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.videocam_rounded, color: Color(0xFF4F46E5)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session['title'] as String,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      session['time'] as String,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isImmediate ? const Color(0xFFFEF2F2) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              session['status'] as String,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isImmediate ? const Color(0xFFEF4444) : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._activities.map((a) => _buildActivityCard(a)),
      ],
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity) {
    IconData icon;
    Color color;

    switch (activity['type']) {
      case 'enrollment':
        icon = Icons.person_add_rounded;
        color = const Color(0xFF10B981);
        break;
      case 'review':
        icon = Icons.star_rounded;
        color = const Color(0xFFF59E0B);
        break;
      case 'message':
      default:
        icon = Icons.chat_bubble_rounded;
        color = const Color(0xFF3B82F6);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12, left: 24, right: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['message'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity['time'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'icon': Icons.add_circle_rounded, 'label': 'Create', 'color': const Color(0xFF3B82F6)},
      {'icon': Icons.schedule_rounded, 'label': 'Schedule', 'color': const Color(0xFF10B981)},
      {'icon': Icons.analytics_rounded, 'label': 'Analytics', 'color': const Color(0xFF6366F1)},
      {'icon': Icons.help_rounded, 'label': 'Support', 'color': Colors.grey.shade600},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: actions.map((action) => _buildActionButton(action)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(Map<String, dynamic> action) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              action['icon'] as IconData,
              color: action['color'] as Color,
              size: 26,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            action['label'] as String,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}
