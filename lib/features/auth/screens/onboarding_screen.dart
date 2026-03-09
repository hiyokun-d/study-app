import 'package:flutter/material.dart';
import 'package:myapp/core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/buttons/primary_button.dart';

/// Modern onboarding screen with page indicators
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    const OnboardingPage(
        icon: Icons.person_search_rounded,
        title: 'Find a Tutor.',
        subtitle:
            'Search tutor based on specific topics and learn exactly what you need.'),
    const OnboardingPage(
      icon: Icons.check_box_rounded,
      title: 'Choose your tutor',
      subtitle:
          'Browse Tutor profiles, experience, and reviews to find the best match for you',
    ),
    const OnboardingPage(
      icon: Icons.book,
      title: 'Learn anything',
      subtitle: 'Keep learning no matter how hard it is',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToNext();
    }
  }

  void _skip() {
    _navigateToNext();
  }

//after the introduction of the app, then this will be showing the next page
  void _navigateToNext() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Skip Button
              // Align(
              //   alignment: Alignment.topRight,
              //   child: Padding(
              //     padding: const EdgeInsets.all(AppSizes.md),
              //     child: TextButton(
              //       onPressed: _skip,
              //       child: Text(
              //         'Skip',
              //         style: TextStyle(
              //           color: colorScheme.onSurface,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),

              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Page Indicators
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? colorScheme.primary
                            : colorScheme.onSurface.withOpacity(0.3),
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusFull),
                      ),
                    );
                  }),
                ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  children: [
                    PrimaryButton(
                      text: _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      onPressed: _nextPage,
                    ),
                    if (_currentPage < _pages.length - 1) ...[
                      const SizedBox(height: AppSizes.md),
                      TextButton(
                        onPressed: _skip,
                        child: Text(
                          'Skip for now',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 7),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Icon(
              page.icon,
              size: 72,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: AppSizes.xxl),

          // Title
          GradientText(
            page.title,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1479FF),
                Color(0xFF147EFF),
                Color(0xFF149AFF),
              ],
              stops: [0.0, 0.46, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            style: theme.textTheme.displaySmall
                ?.copyWith(fontWeight: FontWeight.bold, fontSize: 40),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSizes.md),

          // Subtitle
          Text(
            page.subtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.6,
                fontSize: 16,
                fontWeight: FontWeight.w100),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;

  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    this.style,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}
