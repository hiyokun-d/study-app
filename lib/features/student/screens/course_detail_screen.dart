import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/common/avatar_widget.dart';
import '../../../data/dummy_data.dart';
import '../../../models/course_model.dart';
import '../../../routes/app_routes.dart';

/// Course detail screen showing full course information
class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key, this.courseId});

  final String? courseId;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CourseModel? _course;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCourse();
  }

  void _loadCourse() {
    // For demo, load first course
    if (widget.courseId != null) {
      _course = DummyData.courses.firstWhere(
        (c) => c.id == widget.courseId,
        orElse: () => DummyData.courses.first,
      );
    } else {
      _course = DummyData.courses.first;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _enrollCourse() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EnrollmentBottomSheet(course: _course!),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_course == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildSliverAppBar(),
          ];
        },
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _OverviewTab(course: _course!),
                  _CurriculumTab(course: _course!),
                  _ReviewsTab(course: _course!),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Container(
          padding: const EdgeInsets.all(AppSizes.xs),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(AppSizes.radiusFull),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
          },
          icon: Container(
            padding: const EdgeInsets.all(AppSizes.xs),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? AppColors.error : Colors.white,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: const EdgeInsets.all(AppSizes.xs),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(AppSizes.radiusFull),
            ),
            child: const Icon(Icons.share, color: Colors.white),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.primary.withOpacity(0.1),
          child: Center(
            child: Icon(
              _getCategoryIcon(_course!.category),
              size: 80,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.surface,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: AppStrings.overview),
          Tab(text: AppStrings.curriculum),
          Tab(text: AppStrings.reviews),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.price,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  _course!.formattedPrice,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: PrimaryButton(
                text: _course!.isEnrolled ? AppStrings.continueLearning : AppStrings.enrollNow,
                onPressed: _course!.isEnrolled ? () {} : _enrollCourse,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Overview Tab
class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            course.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          // Teacher card
          _buildTeacherCard(context),
          const SizedBox(height: AppSizes.lg),
          // Stats
          _buildStats(),
          const SizedBox(height: AppSizes.lg),
          // Description
          const Text(
            'About This Course',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            course.description,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          // What you will learn
          if (course.whatYouWillLearn.isNotEmpty) ...[
            const Text(
              AppStrings.whatYouWillLearn,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            ...course.whatYouWillLearn.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSizes.lg),
          // Requirements
          if (course.requirements.isNotEmpty) ...[
            const Text(
              AppStrings.requirements,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            ...course.requirements.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: const Icon(
                        Icons.circle,
                        color: AppColors.textSecondary,
                        size: 8,
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }

  Widget _buildTeacherCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to teacher profile
      },
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Row(
          children: [
            AvatarWidget(
              imageUrl: course.teacher?.avatar,
              name: course.teacher?.name ?? 'Unknown',
              size: 48,
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.teacher?.name ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.9',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      const Icon(
                        Icons.people,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '3.2k students',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm,
                ),
                side: const BorderSide(color: AppColors.primary),
              ),
              child: const Text(AppStrings.subscribe),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _buildStatItem(Icons.star, AppColors.warning, course.rating.toString(),
            '${course.totalRatings} reviews'),
        const SizedBox(width: AppSizes.md),
        _buildStatItem(Icons.people, AppColors.primary,
            course.totalStudents.toString(), 'students'),
        const SizedBox(width: AppSizes.md),
        _buildStatItem(Icons.schedule, AppColors.textSecondary,
            course.formattedDuration, 'duration'),
      ],
    );
  }

  Widget _buildStatItem(
      IconData icon, Color color, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: AppSizes.xs),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Curriculum Tab
class _CurriculumTab extends StatelessWidget {
  const _CurriculumTab({required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(
                    '${course.totalLessons}', AppStrings.lessons),
                Container(
                  width: 1,
                  height: 30,
                  color: AppColors.border,
                ),
                _buildSummaryItem(course.formattedDuration, 'Total'),
                Container(
                  width: 1,
                  height: 30,
                  color: AppColors.border,
                ),
                _buildSummaryItem('2', 'Sections'),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          // Sections
          if (course.sections.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSizes.xl),
                child: Text('Curriculum will be available soon'),
              ),
            )
          else
            ...course.sections.map((section) {
              return _buildSection(section);
            }),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(CourseSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: ExpansionTile(
        title: Text(
          section.title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          '${section.lessons.length} lessons',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        children: section.lessons.map((lesson) {
          return _buildLesson(lesson);
        }).toList(),
      ),
    );
  }

  Widget _buildLesson(LessonModel lesson) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: lesson.isPreview
              ? AppColors.success.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        child: Icon(
          lesson.isPreview ? Icons.play_arrow : Icons.lock,
          size: 16,
          color: lesson.isPreview ? AppColors.success : AppColors.primary,
        ),
      ),
      title: Text(
        lesson.title,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            lesson.formattedDuration,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          if (lesson.isPreview) ...[
            const SizedBox(width: AppSizes.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: const Text(
                'Preview',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Reviews Tab
class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab({required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating summary
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      course.rating.toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 16,
                          color: index < course.rating.floor()
                              ? AppColors.warning
                              : AppColors.border,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      '${course.totalRatings} reviews',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSizes.lg),
                Expanded(
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((star) {
                      final percentage = star == 5
                          ? 0.7
                          : star == 4
                              ? 0.2
                              : star == 3
                                  ? 0.08
                                  : 0.02;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.xs),
                        child: Row(
                          children: [
                            Text(
                              '$star',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: AppSizes.xs),
                            const Icon(
                              Icons.star,
                              size: 12,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: percentage,
                                  backgroundColor: AppColors.border,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    AppColors.warning,
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          // Reviews list
          const Text(
            'Student Reviews',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          ...List.generate(5, (index) {
            return _buildReviewItem(index);
          }),
        ],
      ),
    );
  }

  Widget _buildReviewItem(int index) {
    final reviews = [
      {
        'name': 'Alice Johnson',
        'rating': 5,
        'comment':
            'Excellent course! The instructor explains everything clearly and the content is well-structured.',
        'date': '2 days ago',
      },
      {
        'name': 'Bob Smith',
        'rating': 4,
        'comment':
            'Great course overall. Would love more practical exercises.',
        'date': '1 week ago',
      },
      {
        'name': 'Carol White',
        'rating': 5,
        'comment':
            'Best course I\'ve taken on this platform. Highly recommended!',
        'date': '2 weeks ago',
      },
    ];

    final review = reviews[index % reviews.length];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarWidget(
                name: review['name'] as String,
                size: 40,
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            size: 12,
                            color: i < (review['rating'] as int)
                                ? AppColors.warning
                                : AppColors.border,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                review['date'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            review['comment'] as String,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Enrollment Bottom Sheet
class _EnrollmentBottomSheet extends StatelessWidget {
  const _EnrollmentBottomSheet({required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusXl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          const Text(
            'Confirm Enrollment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSizes.md),
          // Course summary
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Icon(
                    _getCategoryIcon(course.category),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'by ${course.teacher?.name ?? "Unknown"}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.lg),
          // Price breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Course Price',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                course.formattedPrice,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          const Divider(),
          const SizedBox(height: AppSizes.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                course.formattedPrice,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(AppStrings.cancel),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: AppStrings.payNow,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(AppRoutes.payment);
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
        ],
      ),
    );
  }
}

/// Helper function to get category icon
IconData _getCategoryIcon(CourseCategory category) {
  switch (category) {
    case CourseCategory.math:
      return Icons.calculate;
    case CourseCategory.science:
      return Icons.science;
    case CourseCategory.language:
      return Icons.translate;
    case CourseCategory.arts:
      return Icons.palette;
    case CourseCategory.music:
      return Icons.music_note;
    case CourseCategory.coding:
      return Icons.code;
    case CourseCategory.business:
      return Icons.business;
    case CourseCategory.other:
      return Icons.category;
  }
}