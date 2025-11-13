import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';

@Freezed()
abstract class UserSettings with _$UserSettings {
  const factory UserSettings(
      int id,
      int selectedListId,
      ) = _UserSettings;
}
