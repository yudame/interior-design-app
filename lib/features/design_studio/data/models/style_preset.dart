import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'style_preset.freezed.dart';
part 'style_preset.g.dart';

@freezed
class StylePreset with _$StylePreset {
  const StylePreset._();

  const factory StylePreset({
    required String id,
    required String name,
    required String displayName,
    required String description,
    required String iconName,
  }) = _StylePreset;

  factory StylePreset.fromJson(Map<String, dynamic> json) =>
      _$StylePresetFromJson(json);

  IconData get icon => switch (name) {
        'modern_minimalist' => Icons.square_outlined,
        'scandinavian' => Icons.nature,
        'industrial' => Icons.factory_outlined,
        'mid_century_modern' => Icons.chair_outlined,
        'bohemian' => Icons.palette_outlined,
        'contemporary' => Icons.auto_awesome,
        'traditional' => Icons.account_balance_outlined,
        'coastal' => Icons.waves,
        'farmhouse' => Icons.cottage_outlined,
        'art_deco' => Icons.diamond_outlined,
        'japanese_zen' => Icons.spa_outlined,
        'mediterranean' => Icons.wb_sunny_outlined,
        _ => Icons.style_outlined,
      };
}

class StylePresets {
  StylePresets._();

  static const List<StylePreset> all = [
    StylePreset(
      id: 'STY-001',
      name: 'modern_minimalist',
      displayName: 'Modern Minimalist',
      description: 'Clean lines, neutral colors, uncluttered spaces with emphasis on functionality and simplicity',
      iconName: 'square_outlined',
    ),
    StylePreset(
      id: 'STY-002',
      name: 'scandinavian',
      displayName: 'Scandinavian',
      description: 'Light woods, white walls, cozy textiles, functional furniture with hygge comfort',
      iconName: 'nature',
    ),
    StylePreset(
      id: 'STY-003',
      name: 'industrial',
      displayName: 'Industrial',
      description: 'Exposed brick, metal fixtures, raw materials, urban warehouse character',
      iconName: 'factory_outlined',
    ),
    StylePreset(
      id: 'STY-004',
      name: 'mid_century_modern',
      displayName: 'Mid-Century Modern',
      description: 'Organic curves, warm wood tones, iconic furniture pieces from the 1950s-60s era',
      iconName: 'chair_outlined',
    ),
    StylePreset(
      id: 'STY-005',
      name: 'bohemian',
      displayName: 'Bohemian',
      description: 'Eclectic patterns, rich colors, global influences, layered textiles and artistic expression',
      iconName: 'palette_outlined',
    ),
    StylePreset(
      id: 'STY-006',
      name: 'contemporary',
      displayName: 'Contemporary',
      description: 'Current trends, mixed materials, sophisticated color palettes with clean aesthetics',
      iconName: 'auto_awesome',
    ),
    StylePreset(
      id: 'STY-007',
      name: 'traditional',
      displayName: 'Traditional',
      description: 'Classic furniture, rich fabrics, timeless design elements with elegant details',
      iconName: 'account_balance_outlined',
    ),
    StylePreset(
      id: 'STY-008',
      name: 'coastal',
      displayName: 'Coastal',
      description: 'Light blues, whites, natural textures, beach-inspired accents and airy atmosphere',
      iconName: 'waves',
    ),
    StylePreset(
      id: 'STY-009',
      name: 'farmhouse',
      displayName: 'Farmhouse',
      description: 'Rustic wood, vintage elements, comfortable lived-in feel with country charm',
      iconName: 'cottage_outlined',
    ),
    StylePreset(
      id: 'STY-010',
      name: 'art_deco',
      displayName: 'Art Deco',
      description: 'Geometric patterns, bold colors, luxurious materials with glamorous 1920s influence',
      iconName: 'diamond_outlined',
    ),
    StylePreset(
      id: 'STY-011',
      name: 'japanese_zen',
      displayName: 'Japanese Zen',
      description: 'Natural materials, subtle colors, serene atmosphere with mindful minimalism',
      iconName: 'spa_outlined',
    ),
    StylePreset(
      id: 'STY-012',
      name: 'mediterranean',
      displayName: 'Mediterranean',
      description: 'Terracotta, wrought iron, arched doorways, earthy tones with warm European influence',
      iconName: 'wb_sunny_outlined',
    ),
  ];

  static StylePreset? findById(String id) {
    try {
      return all.firstWhere((preset) => preset.id == id);
    } catch (_) {
      return null;
    }
  }

  static StylePreset? findByName(String name) {
    try {
      return all.firstWhere((preset) => preset.name == name);
    } catch (_) {
      return null;
    }
  }
}
