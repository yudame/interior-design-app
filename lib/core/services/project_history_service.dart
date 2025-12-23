import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class ProjectHistoryItem {
  final String id;
  final String styleName;
  final String originalImagePath;
  final String generatedImagePath;
  final DateTime createdAt;

  ProjectHistoryItem({
    required this.id,
    required this.styleName,
    required this.originalImagePath,
    required this.generatedImagePath,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'styleName': styleName,
        'originalImagePath': originalImagePath,
        'generatedImagePath': generatedImagePath,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ProjectHistoryItem.fromJson(Map<String, dynamic> json) {
    return ProjectHistoryItem(
      id: json['id'] as String,
      styleName: json['styleName'] as String,
      originalImagePath: json['originalImagePath'] as String,
      generatedImagePath: json['generatedImagePath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Check if both image files still exist
  bool get imagesExist =>
      File(originalImagePath).existsSync() &&
      File(generatedImagePath).existsSync();
}

class ProjectHistoryService {
  static const _storageKey = 'project_history';

  Future<List<ProjectHistoryItem>> getProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final items = jsonList
          .map((json) => ProjectHistoryItem.fromJson(json))
          .where((item) => item.imagesExist) // Filter out deleted images
          .toList();

      // Sort by newest first
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveProject(ProjectHistoryItem project) async {
    final projects = await getProjects();
    projects.insert(0, project); // Add to beginning

    // Keep only last 50 projects
    final trimmed = projects.take(50).toList();

    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(trimmed.map((p) => p.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> deleteProject(String id) async {
    final projects = await getProjects();
    projects.removeWhere((p) => p.id == id);

    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(projects.map((p) => p.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  Future<ProjectHistoryItem?> getProject(String id) async {
    final projects = await getProjects();
    try {
      return projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
