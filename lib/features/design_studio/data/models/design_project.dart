import 'package:freezed_annotation/freezed_annotation.dart';

part 'design_project.freezed.dart';
part 'design_project.g.dart';

enum RoomType {
  @JsonValue('living_room')
  livingRoom,
  @JsonValue('bedroom')
  bedroom,
  @JsonValue('kitchen')
  kitchen,
  @JsonValue('bathroom')
  bathroom,
  @JsonValue('dining_room')
  diningRoom,
  @JsonValue('office')
  office,
  @JsonValue('outdoor')
  outdoor,
  @JsonValue('other')
  other;

  String get displayName => switch (this) {
        RoomType.livingRoom => 'Living Room',
        RoomType.bedroom => 'Bedroom',
        RoomType.kitchen => 'Kitchen',
        RoomType.bathroom => 'Bathroom',
        RoomType.diningRoom => 'Dining Room',
        RoomType.office => 'Office',
        RoomType.outdoor => 'Outdoor',
        RoomType.other => 'Other',
      };
}

enum ProjectStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('processing')
  processing,
  @JsonValue('completed')
  completed,
  @JsonValue('error')
  error;
}

@freezed
sealed class SyncStatus with _$SyncStatus {
  const factory SyncStatus.synced() = SyncStatusSynced;
  const factory SyncStatus.pending() = SyncStatusPending;
  const factory SyncStatus.error(String message) = SyncStatusError;

  factory SyncStatus.fromJson(Map<String, dynamic> json) =>
      _$SyncStatusFromJson(json);
}

@freezed
class DesignProject with _$DesignProject {
  const factory DesignProject({
    required String id,
    required String userId,
    required String name,
    String? description,
    required RoomType roomType,
    required String originalImageUrl,
    required String originalImagePath,
    @Default(ProjectStatus.draft) ProjectStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(SyncStatus.synced()) SyncStatus syncStatus,
  }) = _DesignProject;

  factory DesignProject.fromJson(Map<String, dynamic> json) =>
      _$DesignProjectFromJson(json);
}
