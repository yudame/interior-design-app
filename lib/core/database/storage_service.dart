import 'dart:typed_data';

import '../utils/result.dart';

abstract class StorageService {
  Future<Result<String>> uploadOriginalImage({
    required String userId,
    required String projectId,
    required Uint8List imageData,
    required String mimeType,
  });

  Future<Result<String>> uploadGeneratedImage({
    required String userId,
    required String projectId,
    required String designId,
    required Uint8List imageData,
  });

  Future<Result<Uint8List>> downloadImage(String path);

  Future<Result<void>> deleteProjectImages(String userId, String projectId);

  Future<Result<String>> getDownloadUrl(String path);
}
