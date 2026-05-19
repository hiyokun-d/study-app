import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_typography.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const _ProfileHeader(),
        const SizedBox(height: AppSizes.lg),
        _buildSectionCard(
          children: [
            _ProfileMenuItem(
              icon: Icons.person_outline_rounded,
              label: 'Edit Profile',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.lock_outline_rounded,
              label: 'Change Password',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.notifications_none_rounded,
              label: 'Notifications',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        _buildSectionCard(
          children: [
            _ProfileMenuItem(
              icon: Icons.help_outline_rounded,
              label: 'Help & Support',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Policy',
              onTap: () {},
            ),
            _ProfileMenuItem(
              icon: Icons.info_outline_rounded,
              label: 'About',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: AppSizes.md),
        _buildSectionCard(
          children: [
            _ProfileMenuItem(
              icon: Icons.logout_rounded,
              label: 'Log Out',
              iconColor: Colors.redAccent,
              labelColor: Colors.redAccent,
              showDivider: false,
              onTap: () {
                AuthState.instance.clear();
                // TODO: navigate to login — e.g. context.go('/login')
              },
            ),
          ],
        ),
        const SizedBox(height: 110),
      ],
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Column(children: children),
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final auth = AuthState.instance;
    final displayName = auth.displayName; // fullName ?? email.split('@')[0] ?? 'Student'
    final email = auth.email ?? '';
    final avatarUrl = auth.avatarUrl;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.lg, AppSizes.lg, AppSizes.lg, AppSizes.md,
        ),
        child: Column(
          children: [
            // Avatar — NetworkImage jika avatarUrl tersedia, fallback ke icon
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 6)),
                ],
                image: avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(avatarUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: avatarUrl == null
                  ? const Icon(Icons.person_rounded, size: 52, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 14),
            // fullName — via displayName getter
            Text(
              displayName,
              style: AppTypography.headline(context).copyWith(color: Colors.white),
            ),
            // email — ditampilkan jika ada
            if (email.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                email,
                style: AppTypography.subtitle(context).copyWith(color: Colors.white70),
              ),
            ],
            const SizedBox(height: 20),
            // Stats row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(value: '0', label: 'Sessions'),
                  _VerticalDivider(),
                  _StatItem(value: '0', label: 'Tutors'),
                  _VerticalDivider(),
                  _StatItem(value: '0', label: 'Hours'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Stat item ────────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: Colors.white30);
  }
}

// ─── Menu Item ───────────────────────────────────────────────────────────────

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final bool showDivider;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveLabelColor = labelColor ?? AppColors.textPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: effectiveIconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: effectiveLabelColor,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textDisabled,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 74, endIndent: 20),
      ],
    );
  }
}