import '../models/design_project.dart';
import '../models/style_preset.dart';

class PromptComposer {
  PromptComposer._();

  static String compose({
    required StylePreset stylePreset,
    required RoomType roomType,
    required String userPrompt,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('''
Redesign this room photograph while maintaining the exact room layout,
dimensions, and architectural features (windows, doors, walls).

Transform the interior design to match the following style:

Style: ${stylePreset.displayName}
${stylePreset.description}

Room type: ${roomType.displayName}
''');

    if (userPrompt.trim().isNotEmpty) {
      buffer.writeln('Additional instructions: $userPrompt');
      buffer.writeln();
    }

    buffer.writeln('''
Requirements:
- Maintain photorealistic quality with 8K resolution detail
- Preserve the room's perspective and lighting direction
- Keep structural elements in their original positions
- Ensure furniture and decor are appropriately scaled
- Apply consistent style throughout the space
''');

    return buffer.toString().trim();
  }
}
