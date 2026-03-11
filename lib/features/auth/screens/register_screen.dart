import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/inputs/text_input.dart';
import '../../../core/widgets/inputs/password_text_field.dart';

/// Register screen - same design as login page
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _acceptTerms = true;
  bool _isLoading = false;
  String _selectedRole = 'student';
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(primary: AppColors.info),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _register() {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms of Service and Privacy Policy'),
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacementNamed('/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: AppColors.info,
      body: Column(
        children: [
          // ── Blue header area ──────────────────────────────────
          SizedBox(height: MediaQuery.of(context).padding.top + AppSizes.md),

          // ── White card body ───────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.lg,
                  AppSizes.xl,
                  AppSizes.lg,
                  AppSizes.lg,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Title ─────────────────────────────────
                      Center(
                        child: Column(
                          children: [
                            Text(
                              AppStrings.createAccount,
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.info,
                              ),
                            ),
                            const SizedBox(height: AppSizes.xs),
                            Text(
                              'Sign up to start your learning journey',
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: AppSizes.lg),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: AppSizes.lg),

                      // ── Role Selection ────────────────────────
                      _buildLabel('I start as a...'),
                      const SizedBox(height: AppSizes.sm),
                      Row(
                        children: [
                          Expanded(
                            child: _buildRoleCard(
                              role: 'student',
                              icon: Icons.school_rounded,
                              label: 'Student',
                            ),
                          ),
                          const SizedBox(width: AppSizes.md),
                          Expanded(
                            child: _buildRoleCard(
                              role: 'teacher',
                              icon: Icons.person_rounded,
                              label: 'Teacher',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSizes.md),

                      // ── Full Name ─────────────────────────────
                      _buildLabel(AppStrings.fullName),
                      const SizedBox(height: AppSizes.xs),
                      TextInput(
                        controller: _nameController,
                        hint: 'Enter your full name',
                        prefixIcon: Icons.person_outline,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        borderColor: AppColors.info,
                        borderRadius: AppSizes.radiusFull,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.fieldRequired;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.md),

                      // ── Date of Birth ─────────────────────────
                      _buildLabel('Date of Birth'),
                      const SizedBox(height: AppSizes.xs),
                      GestureDetector(
                        onTap: _pickDate,
                        child: AbsorbPointer(
                          child: TextFormField(
                            readOnly: true,
                            style: const TextStyle(fontSize: 15),
                            decoration: InputDecoration(
                              hintText: 'DD/MM/YYYY',
                              hintStyle: const TextStyle(
                                color: AppColors.textTertiary,
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.cake_outlined,
                                color: AppColors.info,
                                size: 20,
                              ),
                              suffixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.info,
                                size: 18,
                              ),
                              filled: true,
                              fillColor: AppColors.surface,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.md,
                                vertical: AppSizes.md,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                                borderSide: const BorderSide(
                                    color: AppColors.info, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                                borderSide: const BorderSide(
                                    color: AppColors.info, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 1.5),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                              ),
                            ),
                            controller: TextEditingController(
                              text: _selectedDate != null
                                  ? _formatDate(_selectedDate!)
                                  : '',
                            ),
                            validator: (_) {
                              if (_selectedDate == null) {
                                return 'Please select your date of birth';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSizes.md),

                      // ── Email ─────────────────────────────────
                      _buildLabel(AppStrings.email),
                      const SizedBox(height: AppSizes.xs),
                      TextInput(
                        controller: _emailController,
                        hint: 'Enter your email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        borderColor: AppColors.info,
                        borderRadius: AppSizes.radiusFull,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.fieldRequired;
                          }
                          if (!value.contains('@')) {
                            return AppStrings.invalidEmail;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.md),

                      // ── Password ──────────────────────────────
                      _buildLabel(AppStrings.password),
                      const SizedBox(height: AppSizes.xs),
                      PasswordTextField(
                        controller: _passwordController,
                        hint: 'Enter your password',
                        textInputAction: TextInputAction.next,
                        borderColor: AppColors.info,
                        borderRadius: AppSizes.radiusFull,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.fieldRequired;
                          }
                          if (value.length < 6) {
                            return AppStrings.passwordTooShort;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.md),

                      // ── Confirm Password ──────────────────────
                      _buildLabel(AppStrings.confirmPassword),
                      const SizedBox(height: AppSizes.xs),
                      PasswordTextField(
                        controller: _confirmPasswordController,
                        hint: 'Confirm your password',
                        textInputAction: TextInputAction.done,
                        borderColor: AppColors.info,
                        borderRadius: AppSizes.radiusFull,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.fieldRequired;
                          }
                          if (value != _passwordController.text) {
                            return AppStrings.passwordNotMatch;
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.xl),

                      // ── Or sign up with ───────────────────────
                      Row(
                        children: [
                          const Expanded(child: Divider(color: AppColors.divider)),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.md),
                            child: Text(
                              AppStrings.orSignUpWith,
                              style: textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(color: AppColors.divider)),
                        ],
                      ),

                      const SizedBox(height: AppSizes.lg),

                      // ── Social Buttons ────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialIconButton(
                            onPressed: () {},
                            child: const _GoogleLogo(),
                          ),
                          const SizedBox(width: AppSizes.md),
                          _SocialIconButton(
                            onPressed: () {},
                            child: const _AppleLogo(),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSizes.lg),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: AppSizes.md),

                      // ── Terms Checkbox ────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _acceptTerms,
                              onChanged: (v) =>
                                  setState(() => _acceptTerms = v ?? false),
                              activeColor: AppColors.info,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSizes.sm),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  const TextSpan(text: 'I agree to the '),
                                  TextSpan(
                                    text: AppStrings.termsOfService,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.info,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: AppStrings.privacyPolicy,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.info,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSizes.xl),

                      // ── Register Button ───────────────────────
                      PrimaryButton(
                        text: AppStrings.register,
                        onPressed: _acceptTerms ? _register : null,
                        isLoading: _isLoading,
                        radius: AppSizes.radiusFull,
                        size: ButtonSize.large,
                      ),

                      const SizedBox(height: AppSizes.lg),

                      // ── Login Link ────────────────────────────
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(text: '${AppStrings.haveAccount} '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushReplacementNamed('/login'),
                                  child: Text(
                                    AppStrings.signIn,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.info,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSizes.md),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.info,
      ),
    );
  }

  Widget _buildRoleCard({
    required String role,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppSizes.md,
          horizontal: AppSizes.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.info.withOpacity(0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.info : AppColors.divider,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected ? AppColors.info : AppColors.textSecondary,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.info : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Google Logo ───────────────────────────────────────────────────────────────

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return const FaIcon(
      FontAwesomeIcons.google,
      size: 26,
      color: Color(0xFF4285F4),
    );
  }
}

// ── Apple Logo ────────────────────────────────────────────────────────────────

class _AppleLogo extends StatelessWidget {
  const _AppleLogo();

  @override
  Widget build(BuildContext context) {
    return const FaIcon(
      FontAwesomeIcons.apple,
      size: 28,
      color: Colors.black,
    );
  }
}

// ── Social Icon Button ────────────────────────────────────────────────────────

class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({
    required this.onPressed,
    required this.child,
  });

  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusXl),
          border: Border.all(color: AppColors.info, width: 1.5),
        ),
        child: Center(child: child),
      ),
    );
  }
}