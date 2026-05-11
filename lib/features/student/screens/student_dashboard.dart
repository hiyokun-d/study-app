import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/services/user_api_service.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/common/empty_state.dart';
import '../../../core/widgets/common/loading_widget.dart';
import '../../../core/widgets/inputs/search_input.dart';
import '../../../models/tutor_profile.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;

  static const _gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1565C0), Color(0xFFD6E8FF)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(decoration: const BoxDecoration(gradient: _gradient)),
          ),
          IndexedStack(
            index: _currentIndex,
            children: const [
              _HomeTab(),
              Center(child: Text(AppStrings.schedule, style: TextStyle(color: Colors.white))),
              Center(child: Text(AppStrings.myLearning, style: TextStyle(color: Colors.white))),
              Center(child: Text(AppStrings.profile, style: TextStyle(color: Colors.white))),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 64,
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home_rounded, AppStrings.home),
          _buildNavItem(1, Icons.calendar_today_rounded, AppStrings.schedule),
          _buildNavItem(2, Icons.play_circle_rounded, AppStrings.myLearning),
          _buildNavItem(3, Icons.person_rounded, AppStrings.profile),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? AppColors.primary : AppColors.textDisabled),
          if (!isSelected)
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textDisabled)),
        ],
      ),
    );
  }
}

// ─── Home Tab ────────────────────────────────────────────────────────────────

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  List<TutorProfile>? _tutors;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTutors();
  }

  Future<void> _loadTutors() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await UserApiService.instance.getTutors();

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (result.success) {
        _tutors = result.tutors;
      } else {
        _error = result.errorMessage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildHeader(context),
        _buildSectionLabel('Search Tutor by Topic >'),
        _buildTopicsGrid(),
        _buildSectionLabel('Top Rated Tutor >'),
        _buildTutorSection(context),
        const SizedBox(height: 110),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final displayName = AuthState.instance.displayName;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: AppTypography.subtitle(context).copyWith(color: Colors.white70),
            ),
            Text(
              displayName,
              style: AppTypography.headline(context).copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSizes.lg),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  SearchInput(
                    hint: 'Search tutor...',
                    onChanged: (value) {
                      // TODO: wire to _loadTutors(search: value) with debounce
                    },
                  ),
                  const Divider(height: 32),
                  _buildUpcomingDetail(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingDetail(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Upcoming Session',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              Text(
                'No upcoming session',
                style: AppTypography.title(context).copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 64,
          height: 36,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Book', style: TextStyle(fontSize: 13)),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1A237E),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTopicsGrid() {
    const topics = ['Math', 'Science', 'English', 'Coding', 'Music', 'Art', 'History', 'Language'];
    const icons = [
      Icons.calculate_rounded,
      Icons.science_rounded,
      Icons.menu_book_rounded,
      Icons.code_rounded,
      Icons.music_note_rounded,
      Icons.palette_rounded,
      Icons.public_rounded,
      Icons.translate_rounded,
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
      ),
      itemCount: topics.length,
      itemBuilder: (context, i) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Icon(icons[i], color: AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            topics[i],
            style: const TextStyle(color: Color(0xFF1A237E), fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorSection(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          itemCount: 4,
          itemBuilder: (_, __) => _buildTutorSkeleton(),
        ),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          children: [
            Text(
              'Could not load tutors',
              style: const TextStyle(color: Color(0xFF1A237E), fontSize: 13),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _loadTutors,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_tutors == null || _tutors!.isEmpty) {
      return const EmptyState(message: 'No tutors available');
    }

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
        itemCount: _tutors!.length,
        itemBuilder: (context, i) => _buildTutorCard(_tutors![i]),
      ),
    );
  }

  Widget _buildTutorCard(TutorProfile tutor) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: tutor.avatarUrl != null
                ? NetworkImage(tutor.avatarUrl!)
                : null,
            child: tutor.avatarUrl == null
                ? const Icon(Icons.person)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            tutor.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            tutor.firstSubject.isNotEmpty ? tutor.firstSubject : 'Tutor',
            style: const TextStyle(fontSize: 10, color: AppColors.textDisabled),
          ),
          const SizedBox(height: 4),
          if (tutor.overallRating != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFBBF24)),
                const SizedBox(width: 2),
                Text(
                  tutor.overallRating!.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTutorSkeleton() {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShimmerLoading(
            child: CircleAvatar(radius: 25, backgroundColor: AppColors.surfaceContainerHigh),
          ),
          const SizedBox(height: 8),
          ShimmerLoading(
            child: Container(
              height: 12,
              width: 80,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 4),
          ShimmerLoading(
            child: Container(
              height: 10,
              width: 55,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
