import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/inputs/search_input.dart';
import '../../../core/widgets/common/empty_state.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../data/dummy_data.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        // Tab Switcher
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            HomeTab(),
            Center(child: Text(AppStrings.schedule, style: TextStyle(color: Colors.white))),
            Center(child: Text(AppStrings.myLearning, style: TextStyle(color: Colors.white))),
            Center(child: Text(AppStrings.profile, style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Floating Navigation Bar
  Widget _buildBottomNav() {
    return Container(
      height: 64,
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, 10))],
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

  // Nav Item Widget
  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? AppColors.primary : AppColors.textDisabled),
          if (!isSelected) Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textDisabled)),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    if (DummyData.teachers.isEmpty) return const EmptyState(message: "No tutors available");

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _buildHeader(context),
        _buildSectionLabel(context, 'Search Tutor by Topic >'),
        _buildTopicsGrid(),
        _buildSectionLabel(context, 'Top Rated Tutor >'),
        _buildTutorList(context),
        const SizedBox(height: 110),
      ],
    );
  }

  // Header & Search Section
  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning,', style: AppTypography.subtitle(context).copyWith(color: Colors.white70)),
            Text('Muh Daffa Dwi S.', style: AppTypography.headline(context).copyWith(color: Colors.white)),
            const SizedBox(height: AppSizes.lg),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(32)),
              child: Column(
                children: [
                  const SearchInput(hint: "Search tutor..."),
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

  // Upcoming Session Info
  Widget _buildUpcomingDetail(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Upcoming Session', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
              Text('Dr. Amba Rusdi, S.Kom.', style: AppTypography.title(context).copyWith(fontSize: 14)),
            ],
          ),
        ),
        PrimaryButton(text: 'Join', onPressed: () {}, size: ButtonSize.small),
      ],
    );
  }

  // Section Title Label
  Widget _buildSectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg, vertical: 8),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  // Grid Categories
  Widget _buildTopicsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 10),
      itemCount: 8,
      itemBuilder: (context, i) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.book, color: AppColors.primary),
          ),
          const Text('Topic', style: TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }

  // Horizontal Tutor List
  Widget _buildTutorList(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
        itemCount: DummyData.teachers.length,
        itemBuilder: (context, i) {
          final teacher = DummyData.teachers[i];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(24)),
            child: Column(
              children: [
                const CircleAvatar(radius: 25, child: Icon(Icons.person)),
                const SizedBox(height: 8),
                Text(teacher.user.name, maxLines: 1, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(teacher.expertise.first, style: const TextStyle(fontSize: 10)),
              ],
            ),
          );
        },
      ),
    );
  }
}