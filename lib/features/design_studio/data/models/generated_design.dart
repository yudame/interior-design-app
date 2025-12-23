import 'package:freezed_annotation/freezed_annotation.dart';

import 'style_preset.dart';

part 'generated_design.freezed.dart';
part 'generated_design.g.dart';

enum GenerationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed;
}

@freezed
class GeneratedDesign with _$GeneratedDesign {
  const factory GeneratedDesign({
    required String id,
    required String projectId,
    required String userId,
    required StylePreset stylePreset,
    required String userPrompt,
    required String composedPrompt,
    String? generatedImageUrl,
    String? generatedImagePath,
    @Default(GenerationStatus.pending) GenerationStatus generationStatus,
    String? errorMessage,
    int? processingTimeMs,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _GeneratedDesign;

  factory GeneratedDesign.fromJson(Map<String, dynamic> json) =>
      _$GeneratedDesignFromJson(json);
}
