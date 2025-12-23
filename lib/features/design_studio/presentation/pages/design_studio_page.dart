import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/services/api_key_service.dart';
import '../../../../core/services/gemini_service.dart';
import '../../../../core/services/project_history_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/neon_button.dart';
import '../../data/models/style_preset.dart';
import '../widgets/processing_overlay.dart';
import '../widgets/style_presets/style_preset_card.dart';

class DesignStudioPage extends StatefulWidget {
  final String? projectId;

  const DesignStudioPage({super.key, this.projectId});

  @override
  State<DesignStudioPage> createState() => _DesignStudioPageState();
}

class _DesignStudioPageState extends State<DesignStudioPage> {
  StylePreset? _selectedStyle;
  final _promptController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _apiKeyService = ApiKeyService();
  final _geminiService = GeminiService();
  final _historyService = ProjectHistoryService();
  File? _selectedImage;
  File? _generatedImage;
  bool _showGenerated = false;

  @override
  void initState() {
    super.initState();
    if (widget.projectId != null) {
      _loadProject(widget.projectId!);
    }
  }

  Future<void> _loadProject(String projectId) async {
    final project = await _historyService.getProject(projectId);
    if (project != null && mounted) {
      setState(() {
        _selectedImage = File(project.originalImagePath);
        _generatedImage = File(project.generatedImagePath);
        _showGenerated = true;
        // Find matching style preset
        _selectedStyle = StylePresets.all.cast<StylePreset?>().firstWhere(
          (s) => s?.name == project.styleName,
          orElse: () => null,
        );
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  bool get _canRender => _selectedImage != null && _selectedStyle != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              const Divider(height: 1),

              // Image Viewport
              Expanded(
                child: _buildImageViewport(),
              ),

              // Style Presets
              _buildStylePresetsRow(),

              // Command Footer
              _buildCommandFooter(),
            ],
          ),
        ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'Design Studio',
            style: TextStyle(
              fontFamily: AppTypography.fontFamilyMono,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageViewport() {
    final hasImage = _selectedImage != null;
    final hasGenerated = _generatedImage != null;

    return Column(
      children: [
        // Before/After toggle (only show if we have generated image)
        if (hasGenerated)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleButton('ORIGINAL', !_showGenerated, () {
                  setState(() => _showGenerated = false);
                }),
                const SizedBox(width: 12),
                _buildToggleButton('GENERATED', _showGenerated, () {
                  setState(() => _showGenerated = true);
                }),
              ],
            ),
          ),
        Expanded(
          child: GestureDetector(
            onTap: _showGenerated ? null : _handleImageUpload,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: hasImage
                      ? (_showGenerated ? AppColors.accentPurple : AppColors.accentCyan)
                      : AppColors.gridLine,
                  width: hasImage ? 2 : 1,
                ),
              ),
              child: hasImage
                  ? _buildImageWithHud()
                  : _buildUploadPlaceholder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.accentCyan.withValues(alpha: 0.2)
              : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isActive ? AppColors.accentCyan : AppColors.gridLine,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.dataLabel.copyWith(
            color: isActive ? AppColors.accentCyan : AppColors.textMuted,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 64,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'Tap to upload a photo',
            style: TextStyle(
              fontFamily: AppTypography.fontFamilyBody,
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Camera or Photo Library',
            style: TextStyle(
              fontFamily: AppTypography.fontFamilyBody,
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithHud() {
    final displayImage = _showGenerated && _generatedImage != null
        ? _generatedImage!
        : _selectedImage!;

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.file(
            displayImage,
            fit: BoxFit.cover,
          ),
        ),
        // Tap to change overlay (only for original image)
        if (!_showGenerated)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.backgroundPrimary.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Tap to change',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamilyBody,
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        // Generated indicator
        if (_showGenerated)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentPurple.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 12,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'AI GENERATED',
                    style: AppTypography.dataLabel.copyWith(
                      fontSize: 10,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStylePresetsRow() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: StylePresets.all.length,
        itemBuilder: (context, index) {
          final preset = StylePresets.all[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: StylePresetCard(
              preset: preset,
              isSelected: _selectedStyle?.id == preset.id,
              onTap: () => setState(() => _selectedStyle = preset),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommandFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _promptController,
              style: TextStyle(
                fontFamily: AppTypography.fontFamilyBody,
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Additional instructions (optional)',
                hintStyle: TextStyle(
                  fontFamily: AppTypography.fontFamilyBody,
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                isDense: true,
                filled: true,
                fillColor: AppColors.backgroundSecondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.gridLine),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.gridLine),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.accentCyan),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          NeonButton(
            label: 'Render',
            icon: Icons.auto_awesome,
            onPressed: _canRender ? _handleRender : null,
            isPulsing: _canRender,
          ),
        ],
      ),
    );
  }

  void _handleImageUpload() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose image source',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamilyBody,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: AppColors.accentCyan,
                ),
                title: Text(
                  'Camera',
                  style: AppTypography.terminalText,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.accentPurple,
                ),
                title: Text(
                  'Photo Library',
                  style: AppTypography.terminalText,
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 2048,
        maxHeight: 2048,
        imageQuality: 90,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.statusError,
          ),
        );
      }
    }
  }

  Future<void> _handleRender() async {
    // Check for API key first
    final hasKey = await _apiKeyService.hasApiKey();
    if (!hasKey) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please configure your API key in Settings first'),
            backgroundColor: AppColors.statusWarning,
            action: SnackBarAction(
              label: 'Settings',
              textColor: AppColors.textPrimary,
              onPressed: () => context.push('/settings'),
            ),
          ),
        );
      }
      return;
    }

    // Show processing overlay and call Gemini API
    await ProcessingOverlay.show(
      context,
      processTask: () async {
        final result = await _geminiService.generateDesign(
          originalImage: _selectedImage!,
          styleName: _selectedStyle!.name,
          styleDescription: _selectedStyle!.description,
          additionalPrompt: _promptController.text.isNotEmpty
              ? _promptController.text
              : null,
        );

        result.when(
          success: (file) async {
            if (mounted) {
              setState(() {
                _generatedImage = file;
                _showGenerated = true;
              });

              // Save to history
              await _historyService.saveProject(
                ProjectHistoryItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  styleName: _selectedStyle!.name,
                  originalImagePath: _selectedImage!.path,
                  generatedImagePath: file.path,
                  createdAt: DateTime.now(),
                ),
              );
            }
          },
          failure: (error, _) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: AppColors.statusError,
                ),
              );
            }
          },
          loading: () {},
        );
      },
    );
  }
}
