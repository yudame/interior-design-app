import 'package:flutter_test/flutter_test.dart';
import 'package:interior_design_app/core/services/api_key_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ApiKeyService', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('returns null when no key is stored', () async {
      final service = ApiKeyService();
      final key = await service.getApiKey();
      expect(key, isNull);
    });

    test('hasApiKey returns false for empty key', () async {
      final service = ApiKeyService();
      final hasKey = await service.hasApiKey();
      expect(hasKey, isFalse);
    });

    test('saves and retrieves API key', () async {
      final service = ApiKeyService();
      await service.saveApiKey('test-api-key-123');

      final key = await service.getApiKey();
      expect(key, equals('test-api-key-123'));

      final hasKey = await service.hasApiKey();
      expect(hasKey, isTrue);
    });

    test('deletes API key', () async {
      final service = ApiKeyService();
      await service.saveApiKey('test-api-key-123');
      await service.deleteApiKey();

      final key = await service.getApiKey();
      expect(key, isNull);

      final hasKey = await service.hasApiKey();
      expect(hasKey, isFalse);
    });
  });
}
