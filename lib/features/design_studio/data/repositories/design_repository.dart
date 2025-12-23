import 'dart:typed_data';

import '../../../../core/utils/result.dart';
import '../models/design_project.dart';
import '../models/generated_design.dart';
import '../models/style_preset.dart';

abstract class DesignRepository {
  // Project operations
  Future<Result<DesignProject>> createProject({
    required String userId,
    required String name,
    required RoomType roomType,
    required Uint8List imageData,
    required String mimeType,
    String? description,
  });

  Future<Result<List<DesignProject>>> getProjects(String userId);

  Future<Result<DesignProject>> getProject(String projectId);

  Future<Result<void>> updateProject(DesignProject project);

  Future<Result<void>> deleteProject({
    required String userId,
    required String projectId,
  });

  // Design generation
  Future<Result<GeneratedDesign>> generateDesign({
    required DesignProject project,
    required StylePreset stylePreset,
    required String userPrompt,
  });

  Future<Result<List<GeneratedDesign>>> getDesignsForProject(String projectId);

  Future<Result<GeneratedDesign>> getDesign(String designId);

  // Offline sync
  Future<void> processOfflineQueue();

  Stream<List<DesignProject>> watchProjects(String userId);
}
