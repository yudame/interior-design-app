import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/services/api_key_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/neon_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _apiKeyController = TextEditingController();
  final _apiKeyService = ApiKeyService();
  bool _hasApiKey = false;
  bool _isApiKeyVisible = false;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    try {
      final apiKey = await _apiKeyService.getApiKey();
      if (mounted) {
        setState(() {
          _hasApiKey = apiKey != null && apiKey.isNotEmpty;
          if (_hasApiKey) {
            _apiKeyController.text = apiKey!;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Failed to load API key: $e', isError: true);
      }
    }
  }

  Future<void> _saveApiKey() async {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty) {
      _showSnackBar('Please enter an API key', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      await _apiKeyService.saveApiKey(apiKey);
      if (mounted) {
        setState(() {
          _hasApiKey = true;
          _isSaving = false;
        });
        _showSnackBar('API key saved successfully');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        _showSnackBar('Failed to save API key: $e', isError: true);
      }
    }
  }

  Future<void> _deleteApiKey() async {
    try {
      await _apiKeyService.deleteApiKey();
      if (mounted) {
        setState(() {
          _hasApiKey = false;
          _apiKeyController.clear();
        });
        _showSnackBar('API key removed');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to delete API key: $e', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? AppColors.statusError : AppColors.statusSuccess,
      ),
    );
  }

  Future<void> _openAiStudio() async {
    final uri = Uri.parse('https://aistudio.google.com/apikey');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'SETTINGS',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamilyMono,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.accentCyan,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Settings list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildApiKeySection(),
                    const SizedBox(height: 24),
                    _buildSection(
                      'APPLICATION',
                      [
                        _buildSettingItem(
                          icon: Icons.palette_outlined,
                          title: 'Appearance',
                          subtitle: 'Theme settings',
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: Icons.storage_outlined,
                          title: 'Storage',
                          subtitle: 'Manage cached data',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      'SUPPORT',
                      [
                        _buildSettingItem(
                          icon: Icons.help_outline,
                          title: 'Help',
                          subtitle: 'FAQ and documentation',
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: Icons.info_outline,
                          title: 'About',
                          subtitle: 'Version 1.0.0',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }

  Widget _buildApiKeySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'AI CONFIGURATION',
              style: AppTypography.dataLabel,
            ),
            const SizedBox(width: 8),
            if (_hasApiKey)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.statusSuccess.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'CONFIGURED',
                  style: AppTypography.dataLabel.copyWith(
                    fontSize: 9,
                    color: AppColors.statusSuccess,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.key,
                    color: AppColors.accentCyan,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Google AI API Key',
                      style: AppTypography.terminalText,
                    ),
                  ),
                  TextButton(
                    onPressed: _openAiStudio,
                    child: Text(
                      'Get Key',
                      style: AppTypography.dataLabel.copyWith(
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(
                      color: AppColors.accentCyan,
                    ),
                  ),
                )
              else ...[
                TextField(
                  controller: _apiKeyController,
                  obscureText: !_isApiKeyVisible,
                  style: AppTypography.terminalText.copyWith(
                    fontSize: 12,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Paste your API key here...',
                    hintStyle: AppTypography.terminalText.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            _isApiKeyVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() => _isApiKeyVisible = !_isApiKeyVisible);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.paste,
                            color: AppColors.textMuted,
                            size: 20,
                          ),
                          onPressed: () async {
                            final data = await Clipboard.getData('text/plain');
                            if (data?.text != null) {
                              _apiKeyController.text = data!.text!;
                            }
                          },
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: NeonButton(
                        label: 'Save Key',
                        icon: Icons.save,
                        isLoading: _isSaving,
                        onPressed: _saveApiKey,
                      ),
                    ),
                    if (_hasApiKey) ...[
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: _deleteApiKey,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.statusError,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Text(
                'Your API key is stored securely on your device and is never sent to our servers.',
                style: AppTypography.dataLabel.copyWith(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.dataLabel,
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.accentCyan,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.terminalText,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.dataLabel,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
