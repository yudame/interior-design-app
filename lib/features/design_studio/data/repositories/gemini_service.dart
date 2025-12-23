import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'gemini_service.freezed.dart';

enum GeminiErrorType {
  rateLimitExceeded,
  invalidImage,
  contentFiltered,
  modelOverloaded,
  networkError,
  unknown;

  String get userMessage => switch (this) {
        GeminiErrorType.rateLimitExceeded => 'Too many requests. Please wait a moment.',
        GeminiErrorType.invalidImage => 'Unable to process this image. Try a different photo.',
        GeminiErrorType.contentFiltered => 'Content was filtered. Please modify your prompt.',
        GeminiErrorType.modelOverloaded => 'AI service is busy. Please try again.',
        GeminiErrorType.networkError => 'Network error. Check your connection.',
        GeminiErrorType.unknown => 'An unexpected error occurred.',
      };

  bool get isRetryable => switch (this) {
        GeminiErrorType.rateLimitExceeded => true,
        GeminiErrorType.modelOverloaded => true,
        GeminiErrorType.networkError => true,
        GeminiErrorType.invalidImage => false,
        GeminiErrorType.contentFiltered => false,
        GeminiErrorType.unknown => false,
      };

  Duration get baseRetryDelay => switch (this) {
        GeminiErrorType.rateLimitExceeded => const Duration(seconds: 60),
        GeminiErrorType.modelOverloaded => const Duration(seconds: 30),
        GeminiErrorType.networkError => const Duration(seconds: 5),
        _ => Duration.zero,
      };
}

@freezed
sealed class GeminiGenerationResult with _$GeminiGenerationResult {
  const factory GeminiGenerationResult.success({
    required Uint8List imageData,
    String? textResponse,
    required int processingTimeMs,
  }) = GeminiSuccess;

  const factory GeminiGenerationResult.failure({
    required String errorMessage,
    required GeminiErrorType errorType,
  }) = GeminiFailure;
}

abstract class GeminiService {
  Future<GeminiGenerationResult> generateDesign({
    required Uint8List originalImage,
    required String mimeType,
    required String composedPrompt,
  });
}
