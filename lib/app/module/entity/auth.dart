import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.g.dart';
part 'auth.freezed.dart';

@freezed
sealed class Auth with _$Auth {
  factory Auth.entity(
      {required String email,
      required String password,
      @JsonKey(name: 'device_id') String? deviceId}) = AuthEntity;

  factory Auth.fromJson(Map<String, Object> json) => _$AuthFromJson(json);
}
