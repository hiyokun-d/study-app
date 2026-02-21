import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../routes/app_routes.dart';

/// Subscription plans screen showing available plans
class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  bool _isYearly = false;
  int _selectedPlan = 1; // 0: Free, 1: Premium, 2: Pro

  final List<SubscriptionPlan> _plans = const [
    SubscriptionPlan(
      id: 'free',
      name: 'Free',
      monthlyPrice: 0,
      yearlyPrice: 0,
      features: [
        'Access to free courses',
        'Basic course previews',
        'Limited live class access',
        'Community forum access',
      ],
      limitations: [
        'No certificates',
        'No 1-on-1 sessions',
      ],
    ),
    SubscriptionPlan(
      id: 'premium',
      name: 'Premium',
      monthlyPrice: 9.99,
      yearlyPrice: 99.99,
      features: [
        'Access to all courses',
        'Unlimited live classes',
        'Download for offline',
        'Course certificates',
        'Priority support',
        '5 1-on-1 sessions/month',
      ],
      isPopular: true,
    ),
    SubscriptionPlan(
      id: 'pro',
      name: 'Pro',
      monthlyPrice: 19.99,
      yearlyPrice: 199.99,
      features: [
        'Everything in Premium',
        'Unlimited 1-on-1 sessions',
        'Personal learning coach',
        'Career guidance',
        'Exclusive workshops',
        'Early access to new courses',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: const Text(
          AppStrings.subscriptionPlans,
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: AppSizes.lg),
            // Billing toggle
            _buildBillingToggle(),
            const SizedBox(height: AppSizes.lg),
            // Plans
            ..._plans.asMap().entries.map((entry) {
              return _buildPlanCard(entry.key, entry.value);
            }),
            const SizedBox(height: AppSizes.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.workspace_premium,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: AppSizes.md),
          const Text(
            'Unlock Your Potential',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'Choose the plan that fits your learning goals',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBillingToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      padding: const EdgeInsets.all(AppSizes.xs),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleOption('Monthly', !_isYearly, () {
              setState(() {
                _isYearly = false;
              });
            }),
          ),
          Expanded(
            child: _buildToggleOption('Yearly (Save 17%)', _isYearly, () {
              setState(() {
                _isYearly = true;
              });
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPlanCard(int index, SubscriptionPlan plan) {
    final isSelected = _selectedPlan == index;
    final price = _isYearly ? plan.yearlyPrice : plan.monthlyPrice;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.sm,
        ),
        padding: const EdgeInsets.all(AppSizes.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            plan.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (plan.isPopular) ...[
                            const SizedBox(width: AppSizes.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.sm,
                                vertical: AppSizes.xs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                              ),
                              child: const Text(
                                'Popular',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            price == 0 ? 'Free' : '\$${price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          if (price > 0) ...[
                            const SizedBox(width: AppSizes.xs),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(
                                _isYearly ? '/year' : '/month',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Selection indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            // Features
            ...plan.features.map((feature) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            // Limitations
            if (plan.limitations != null)
              ...plan.limitations!.map((limitation) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.sm),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel,
                        color: AppColors.textDisabled,
                        size: 20,
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Text(
                        limitation,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textDisabled,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

/// Subscription plan model
class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.features,
    this.limitations,
    this.isPopular = false,
  });

  final String id;
  final String name;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final List<String>? limitations;
  final bool isPopular;
}
