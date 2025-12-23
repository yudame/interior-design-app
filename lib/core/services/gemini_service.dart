import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/result.dart';
import 'api_key_service.dart';

class GeminiService {
  static const _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const _model = 'gemini-2.0-flash-exp-image-generation';

  final ApiKeyService _apiKeyService;
  final Dio _dio;

  GeminiService({
    ApiKeyService? apiKeyService,
    Dio? dio,
  })  : _apiKeyService = apiKeyService ?? ApiKeyService(),
        _dio = dio ?? Dio();

  /// Generates a redesigned room image based on the original image and style.
  Future<Result<File>> generateDesign({
    required File originalImage,
    required String styleName,
    required String styleDescription,
    String? additionalPrompt,
  }) async {
    try {
      final apiKey = await _apiKeyService.getApiKey();
      if (apiKey == null || apiKey.isEmpty) {
        return const Result.failure(
          'API key not configured. Please add your Google AI API key in Settings.',
        );
      }

      // Read and encode the image
      final imageBytes = await originalImage.readAsBytes();
      final base64Image = base64Encode(imageBytes);
      final mimeType = _getMimeType(originalImage.path);

      // Compose the prompt
      final prompt = _composePrompt(
        styleName: styleName,
        styleDescription: styleDescription,
        additionalPrompt: additionalPrompt,
      );

      // Build request body
      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': prompt,
              },
              {
                'inlineData': {
                  'mimeType': mimeType,
                  'data': base64Image,
                },
              },
            ],
          },
        ],
        'generationConfig': {
          'responseModalities': ['TEXT', 'IMAGE'],
        },
      };

      // Make API request
      final response = await _dio.post(
        '$_baseUrl/models/$_model:generateContent',
        queryParameters: {'key': apiKey},
        data: requestBody,
        options: Options(
          headers: {'Content-Type': 'application/json'},
          sendTimeout: const Duration(seconds: 120),
          receiveTimeout: const Duration(seconds: 120),
        ),
      );

      if (response.statusCode != 200) {
        return Result.failure(
          'API request failed with status ${response.statusCode}',
        );
      }

      // Parse response and extract image
      final responseData = response.data as Map<String, dynamic>;
      final generatedImage = _extractImageFromResponse(responseData);

      if (generatedImage == null) {
        return const Result.failure(
          'No image was generated. The AI may have been unable to process your request.',
        );
      }

      // Save the generated image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputFile = File('${tempDir.path}/generated_$timestamp.png');
      await outputFile.writeAsBytes(generatedImage);

      return Result.success(outputFile);
    } on DioException catch (e) {
      final errorMessage = _parseDioError(e);
      return Result.failure(errorMessage);
    } catch (e) {
      return Result.failure('An unexpected error occurred: $e');
    }
  }

  String _composePrompt({
    required String styleName,
    required String styleDescription,
    String? additionalPrompt,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('''
Edit this room photo to show a professionally styled $styleName interior.

STRICTLY PRESERVE (do not change):
- Exact room dimensions and shape
- All walls in their current positions
- All doors and windows (same size, same location)
- Built-in features (closets, shelving, fireplaces)
- Camera angle and perspective
- Overall lighting direction

TRANSFORM (replace with high-end $styleName alternatives):
- Furniture (swap for stylish, coordinated pieces)
- Wall paint/color
- Flooring appearance
- Decor and accessories
- Textiles and soft furnishings
- Light fixtures

Style: $styleName - $styleDescription

Create a beautiful, magazine-quality result while keeping the room's architecture intact.
''');

    if (additionalPrompt != null && additionalPrompt.trim().isNotEmpty) {
      buffer.writeln('\nAdditional instructions: $additionalPrompt');
    }

    return buffer.toString();
  }

  String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'heic':
        return 'image/heic';
      default:
        return 'image/jpeg';
    }
  }

  Uint8List? _extractImageFromResponse(Map<String, dynamic> response) {
    try {
      final candidates = response['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) return null;

      final content = candidates[0]['content'] as Map<String, dynamic>?;
      if (content == null) return null;

      final parts = content['parts'] as List?;
      if (parts == null) return null;

      // Look for inline image data in parts
      for (final part in parts) {
        if (part is Map<String, dynamic>) {
          final inlineData = part['inlineData'] as Map<String, dynamic>?;
          if (inlineData != null && inlineData['data'] != null) {
            final base64Data = inlineData['data'] as String;
            return base64Decode(base64Data);
          }
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  String _parseDioError(DioException e) {
    if (e.response?.data != null) {
      try {
        final data = e.response!.data;
        if (data is Map<String, dynamic>) {
          final error = data['error'] as Map<String, dynamic>?;
          if (error != null) {
            final message = error['message'] as String?;
            if (message != null) {
              if (message.contains('API_KEY_INVALID')) {
                return 'Invalid API key. Please check your API key in Settings.';
              }
              if (message.contains('QUOTA_EXCEEDED')) {
                return 'API quota exceeded. Please try again later.';
              }
              if (message.contains('SAFETY')) {
                return 'The image was blocked by safety filters. Please try a different image.';
              }
              return message;
            }
          }
        }
      } catch (_) {}
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.connectionError:
        return 'Unable to connect. Please check your internet connection.';
      default:
        return 'Network error: ${e.message}';
    }
  }
}
