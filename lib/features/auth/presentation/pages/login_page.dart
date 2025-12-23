import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/neon_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    // TODO: Implement Firebase Auth
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (mounted) {
      context.go('/gallery');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Interior Design',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamilyMono,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accentCyan,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'INTERIOR DESIGN SYSTEM',
                    style: AppTypography.dataLabel,
                  ),
                  const SizedBox(height: 48),
                  GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'AUTHENTICATION',
                          style: AppTypography.dataLabel,
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: AppTypography.terminalText,
                          decoration: const InputDecoration(
                            labelText: 'EMAIL',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: AppTypography.terminalText,
                          decoration: const InputDecoration(
                            labelText: 'PASSWORD',
                            prefixIcon: Icon(
                              Icons.lock_outlined,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        NeonButton(
                          label: 'Initialize Session',
                          onPressed: _handleLogin,
                          isLoading: _isLoading,
                          isPulsing: true,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => context.go('/auth/signup'),
                          child: Text(
                            'CREATE NEW ACCOUNT',
                            style: AppTypography.dataLabel.copyWith(
                              color: AppColors.accentCyan,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
