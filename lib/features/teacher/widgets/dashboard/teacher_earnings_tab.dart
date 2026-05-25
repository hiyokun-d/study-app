import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';

class TeacherEarningsTab extends StatelessWidget {
  const TeacherEarningsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Wrapped in a Container to apply the requested 3-color gradient
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3B82F6), // Vivid blue
            Color(0xFF93C5FD), // Light blue
            Color(0xFFFFFFFF), // White
          ],
          stops: [0.0, 0.4, 1.0],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Earnings',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white, // Updated to white to contrast with the blue background
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Container(
                padding: const EdgeInsets.all(AppSizes.lg),
                decoration: BoxDecoration(
                  // Deep blue gradient for the main card to pop visually
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF1E40AF),
                      Color(0xFF3B82F6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E40AF).withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Balance',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      '\$12,450.00',
                      style: textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('This Month',
                                  style: textTheme.bodySmall?.copyWith(
                                      color: Colors.white70)),
                              Text('\$4,560.00',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pending',
                                  style: textTheme.bodySmall?.copyWith(
                                      color: Colors.white70)),
                              Text('\$890.00',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                'Recent Transactions',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B), // Dark slate for readability
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              ...List.generate(5, (index) => _buildTransactionItem(context, index)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, int index) {
    final textTheme = Theme.of(context).textTheme;
    final isIncome = index % 2 == 0;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white, // Clean white floating card
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), // Soft shadow instead of the flat outline border
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isIncome
                  ? const Color(0xFFD1FAE5) // Soft green bg
                  : const Color(0xFFFEE2E2), // Soft red bg
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              size: 22,
              color: isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isIncome ? 'Course Purchase' : 'Withdrawal',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Feb ${20 - index}, 2024',
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            isIncome
                ? '+\$${(index + 1) * 25}.00'
                : '-\$${(index + 1) * 100}.00',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }
}