import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/project_history_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/neon_button.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final _historyService = ProjectHistoryService();
  List<ProjectHistoryItem> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final projects = await _historyService.getProjects();
    if (mounted) {
      setState(() {
        _projects = projects;
        _isLoading = false;
      });
    }
  }

  Future<void> _viewProject(ProjectHistoryItem project) async {
    await context.push('/studio/${project.id}');
    _loadProjects(); // Refresh after returning
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
                  Text(
                    'Interior Design',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamilyMono,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accentCyan,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    key: const ValueKey('settings_button'),
                    tooltip: 'Settings',
                    onPressed: () => context.push('/settings'),
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Projects list
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accentCyan,
                      ),
                    )
                  : _projects.isEmpty
                      ? _buildEmptyState()
                      : _buildProjectsList(),
            ),

            // New project button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: NeonButton(
                  label: 'New Project',
                  icon: Icons.add,
                  onPressed: () async {
                    await context.push('/studio');
                    _loadProjects(); // Refresh after returning
                  },
                  isPulsing: _projects.isEmpty,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.architecture_outlined,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 24),
            Text(
              'NO PROJECTS YET',
              style: AppTypography.dataLabel.copyWith(
                fontSize: 14,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first interior design',
              style: TextStyle(
                fontFamily: AppTypography.fontFamilyBody,
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _projects.length,
      itemBuilder: (context, index) {
        final project = _projects[index];
        return _buildProjectCard(project);
      },
    );
  }

  Widget _buildProjectCard(ProjectHistoryItem project) {
    final timeAgo = _formatTimeAgo(project.createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () => _viewProject(project),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: Image.file(
                      File(project.generatedImagePath),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.backgroundTertiary,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.styleName,
                        style: AppTypography.terminalText.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        timeAgo,
                        style: AppTypography.dataLabel.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays > 30) {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
