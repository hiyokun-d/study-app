import 'package:flutter/material.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/common/avatar_widget.dart';
import '../../../data/dummy_data.dart';
import '../../../models/course_model.dart';

/// Modern course detail screen with theme-aware styling
class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CourseModel _course;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _course = DummyData.courses.firstWhere(
      (c) => c.id == widget.courseId,
      orElse: () => DummyData.courses.first,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildSliverAppBar(context),
          ];
        },
        body: Column(
          children: [
            _buildTabBar(context),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _OverviewTab(course: _course),
                  _CurriculumTab(course: _course),
                  _ReviewsTab(course: _course),
                  _TeacherTab(course: _course),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Container(
          padding: const EdgeInsets.all(AppSizes.xs),
          decoration: BoxDecoration(
            color: colorScheme.surface.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() => _isBookmarked = !_isBookmarked);
          },
          icon: Container(
            padding: const EdgeInsets.all(AppSizes.xs),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isBookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              size: 18,
              color: _isBookmarked
                  ? colorScheme.primary
                  : colorScheme.onSurface,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: const EdgeInsets.all(AppSizes.xs),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.share_rounded,
              size: 18,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primaryContainer,
                colorScheme.primaryContainer.withOpacity(0.3),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.play_circle_outline,
              size: 64,
              color: colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: colorScheme.primary,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Curriculum'),
          Tab(text: 'Reviews'),
          Tab(text: 'Teacher'),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSizes.md,
        AppSizes.md,
        AppSizes.md,
        MediaQuery.of(context).padding.bottom + AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '\$${_course.price.toStringAsFixed(0)}',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppSizes.lg),
          Expanded(
            child: PrimaryButton(
              text: AppStrings.enrollNow,
              onPressed: () {},
            ),
          ),
        ],
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            course.title,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          
          const SizedBox(height: AppSizes.sm),
          
          // Teacher Row
          Row(
            children: [
              AvatarWidget(
                name: course.teacher?.name ?? 'Teacher',
                size: AvatarSize.small,
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                course.teacher?.name ?? 'Teacher',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSizes.md),
          
          // Stats Row
          _buildStatsRow(context),
          
          const SizedBox(height: AppSizes.lg),
          
          // Description
          Text(
            'About this course',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            course.description,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // What you'll learn
          Text(
            'What you\'ll learn',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          ..._buildLearningPoints(context),
          
          const SizedBox(height: AppSizes.lg),
          
          // Requirements
          Text(
            'Requirements',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          ..._buildRequirements(context),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            icon: Icons.star_rounded,
            label: 'Rating',
            value: course.rating.toStringAsFixed(1),
            color: const Color(0xFFFFB800),
          ),
          _buildStatItem(
            context,
            icon: Icons.people_outline,
            label: 'Students',
            value: '${course.totalStudents}',
          ),
          _buildStatItem(
            context,
            icon: Icons.schedule_outlined,
            label: 'Duration',
            value: course.formattedDuration,
          ),
          _buildStatItem(
            context,
            icon: Icons.update_outlined,
            label: 'Updated',
            value: 'Recently',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: color ?? colorScheme.primary,
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          value,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildLearningPoints(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final points = [
      'Understand the fundamentals of the subject',
      'Apply concepts to real-world scenarios',
      'Build practical projects from scratch',
      'Master advanced techniques',
    ];

    return points.map((point) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 20,
              color: colorScheme.primary,
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Text(
                point,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildRequirements(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final requirements = [
      'No prior experience required',
      'A computer with internet access',
      'Willingness to learn',
    ];

    return requirements.map((req) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.arrow_right_rounded,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSizes.xs),
            Expanded(
              child: Text(
                req,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

/// Curriculum Tab
class _CurriculumTab extends StatelessWidget {
  const _CurriculumTab({required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Mock curriculum data
    final sections = [
      {
        'title': 'Introduction',
        'lessons': [
          {'title': 'Welcome to the course', 'duration': '5:00', 'preview': true},
          {'title': 'What you will learn', 'duration': '3:00', 'preview': true},
        ],
      },
      {
        'title': 'Getting Started',
        'lessons': [
          {'title': 'Setting up your environment', 'duration': '10:00', 'preview': false},
          {'title': 'Basic concepts', 'duration': '15:00', 'preview': false},
          {'title': 'Your first project', 'duration': '20:00', 'preview': false},
        ],
      },
      {
        'title': 'Advanced Topics',
        'lessons': [
          {'title': 'Advanced techniques', 'duration': '25:00', 'preview': false},
          {'title': 'Best practices', 'duration': '15:00', 'preview': false},
        ],
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary
          Container(
            padding: const EdgeInsets.all(AppSizes.md),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${sections.length} Sections',
                  style: textTheme.titleSmall,
                ),
                Text(
                  '${sections.fold(0, (sum, s) => sum + (s['lessons'] as List).length)} Lessons',
                  style: textTheme.titleSmall,
                ),
                Text(
                  '2h 30m',
                  style: textTheme.titleSmall,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Sections
          ...sections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            return _buildSection(
              context,
              sectionNumber: index + 1,
              title: section['title'] as String,
              lessons: section['lessons'] as List<Map<String, dynamic>>,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required int sectionNumber,
    required String title,
    required List<Map<String, dynamic>> lessons,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Center(
                  child: Text(
                    '$sectionNumber',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${lessons.length} lessons',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        
        // Lessons
        ...lessons.map((lesson) {
          return _buildLessonItem(context, lesson);
        }),
        
        const SizedBox(height: AppSizes.md),
      ],
    );
  }

  Widget _buildLessonItem(
    BuildContext context,
    Map<String, dynamic> lesson,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.md,
        vertical: AppSizes.sm,
      ),
      child: Row(
        children: [
          Icon(
            lesson['preview'] == true
                ? Icons.play_circle_outline
                : Icons.lock_outline,
            size: 20,
            color: lesson['preview'] == true
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              lesson['title'] as String,
              style: textTheme.bodyMedium?.copyWith(
                color: lesson['preview'] == true
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (lesson['preview'] == true)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm,
                vertical: AppSizes.xs,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Text(
                'Preview',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          const SizedBox(width: AppSizes.sm),
          Text(
            lesson['duration'] as String,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Mock reviews
    final reviews = [
      {
        'name': 'Alice Johnson',
        'rating': 5,
        'comment': 'Excellent course! The instructor explains everything clearly.',
        'date': '2 days ago',
      },
      {
        'name': 'Bob Smith',
        'rating': 4,
        'comment': 'Great content, but could use more practical examples.',
        'date': '1 week ago',
      },
      {
        'name': 'Carol White',
        'rating': 5,
        'comment': 'Best course I\'ve taken on this platform!',
        'date': '2 weeks ago',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Summary
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      course.rating.toStringAsFixed(1),
                      style: textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: index < course.rating.floor()
                              ? const Color(0xFFFFB800)
                              : colorScheme.outline,
                        );
                      }),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      '${course.totalStudents} reviews',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: AppSizes.lg),
                Expanded(
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((stars) {
                      final percent = stars == 5
                          ? 0.7
                          : stars == 4
                              ? 0.2
                              : stars == 3
                                  ? 0.08
                                  : 0.02;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.xs),
                        child: Row(
                          children: [
                            Text(
                              '$stars',
                              style: textTheme.bodySmall,
                            ),
                            const SizedBox(width: AppSizes.xs),
                            Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: const Color(0xFFFFB800),
                            ),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  AppSizes.radiusFull,
                                ),
                                child: LinearProgressIndicator(
                                  value: percent,
                                  backgroundColor: colorScheme.outlineVariant,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    const Color(0xFFFFB800),
                                  ),
                                  minHeight: 4,
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
          
          // Reviews List
          ...reviews.map((review) {
            return _buildReviewItem(context, review);
          }),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
    BuildContext context,
    Map<String, dynamic> review,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarWidget(
                name: review['name'] as String,
                size: AvatarSize.small,
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'] as String,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: index < (review['rating'] as int)
                                ? const Color(0xFFFFB800)
                                : colorScheme.outline,
                          );
                        }),
                        const SizedBox(width: AppSizes.sm),
                        Text(
                          review['date'] as String,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            review['comment'] as String,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Teacher Tab
class _TeacherTab extends StatelessWidget {
  const _TeacherTab({required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teacher Card
          Container(
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Column(
              children: [
                AvatarWidget(
                  name: course.teacher?.name ?? 'Teacher',
                  size: AvatarSize.extraLarge,
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  course.teacher?.name ?? 'Teacher',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  'Expert Instructor',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStat(context, '4.9', 'Rating'),
                    const SizedBox(width: AppSizes.lg),
                    _buildStat(context, '1.2K', 'Students'),
                    const SizedBox(width: AppSizes.lg),
                    _buildStat(context, '15', 'Courses'),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Bio
          Text(
            'About',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'An experienced instructor with over 10 years of teaching experience. '
            'Passionate about helping students achieve their learning goals through '
            'practical, hands-on instruction.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          
          const SizedBox(height: AppSizes.lg),
          
          // Subscribe Button
          PrimaryButton(
            text: 'Subscribe to Teacher',
            onPressed: () {},
            isOutlined: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
