// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EmployeeEntity _$EmployeeEntityFromJson(Map<String, dynamic> json) {
  return _EmployeeEntity.fromJson(json);
}

/// @nodoc
mixin _$EmployeeEntity {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_url')
  String? get imageUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'attendance_status')
  String? get attendanceStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_attendance_time')
  String? get lastAttendanceTime => throw _privateConstructorUsedError;

  /// Serializes this EmployeeEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EmployeeEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EmployeeEntityCopyWith<EmployeeEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeEntityCopyWith<$Res> {
  factory $EmployeeEntityCopyWith(
    EmployeeEntity value,
    $Res Function(EmployeeEntity) then,
  ) = _$EmployeeEntityCopyWithImpl<$Res, EmployeeEntity>;
  @useResult
  $Res call({
    int id,
    String name,
    String? email,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'attendance_status') String? attendanceStatus,
    @JsonKey(name: 'last_attendance_time') String? lastAttendanceTime,
  });
}

/// @nodoc
class _$EmployeeEntityCopyWithImpl<$Res, $Val extends EmployeeEntity>
    implements $EmployeeEntityCopyWith<$Res> {
  _$EmployeeEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EmployeeEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? imageUrl = freezed,
    Object? attendanceStatus = freezed,
    Object? lastAttendanceTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            attendanceStatus: freezed == attendanceStatus
                ? _value.attendanceStatus
                : attendanceStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastAttendanceTime: freezed == lastAttendanceTime
                ? _value.lastAttendanceTime
                : lastAttendanceTime // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EmployeeEntityImplCopyWith<$Res>
    implements $EmployeeEntityCopyWith<$Res> {
  factory _$$EmployeeEntityImplCopyWith(
    _$EmployeeEntityImpl value,
    $Res Function(_$EmployeeEntityImpl) then,
  ) = __$$EmployeeEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String? email,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'attendance_status') String? attendanceStatus,
    @JsonKey(name: 'last_attendance_time') String? lastAttendanceTime,
  });
}

/// @nodoc
class __$$EmployeeEntityImplCopyWithImpl<$Res>
    extends _$EmployeeEntityCopyWithImpl<$Res, _$EmployeeEntityImpl>
    implements _$$EmployeeEntityImplCopyWith<$Res> {
  __$$EmployeeEntityImplCopyWithImpl(
    _$EmployeeEntityImpl _value,
    $Res Function(_$EmployeeEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EmployeeEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = freezed,
    Object? imageUrl = freezed,
    Object? attendanceStatus = freezed,
    Object? lastAttendanceTime = freezed,
  }) {
    return _then(
      _$EmployeeEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        attendanceStatus: freezed == attendanceStatus
            ? _value.attendanceStatus
            : attendanceStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastAttendanceTime: freezed == lastAttendanceTime
            ? _value.lastAttendanceTime
            : lastAttendanceTime // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeEntityImpl implements _EmployeeEntity {
  const _$EmployeeEntityImpl({
    required this.id,
    required this.name,
    this.email,
    @JsonKey(name: 'image_url') this.imageUrl,
    @JsonKey(name: 'attendance_status') this.attendanceStatus,
    @JsonKey(name: 'last_attendance_time') this.lastAttendanceTime,
  });

  factory _$EmployeeEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeEntityImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? email;
  @override
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @override
  @JsonKey(name: 'attendance_status')
  final String? attendanceStatus;
  @override
  @JsonKey(name: 'last_attendance_time')
  final String? lastAttendanceTime;

  @override
  String toString() {
    return 'EmployeeEntity(id: $id, name: $name, email: $email, imageUrl: $imageUrl, attendanceStatus: $attendanceStatus, lastAttendanceTime: $lastAttendanceTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.attendanceStatus, attendanceStatus) ||
                other.attendanceStatus == attendanceStatus) &&
            (identical(other.lastAttendanceTime, lastAttendanceTime) ||
                other.lastAttendanceTime == lastAttendanceTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    email,
    imageUrl,
    attendanceStatus,
    lastAttendanceTime,
  );

  /// Create a copy of EmployeeEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeEntityImplCopyWith<_$EmployeeEntityImpl> get copyWith =>
      __$$EmployeeEntityImplCopyWithImpl<_$EmployeeEntityImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeEntityImplToJson(this);
  }
}

abstract class _EmployeeEntity implements EmployeeEntity {
  const factory _EmployeeEntity({
    required final int id,
    required final String name,
    final String? email,
    @JsonKey(name: 'image_url') final String? imageUrl,
    @JsonKey(name: 'attendance_status') final String? attendanceStatus,
    @JsonKey(name: 'last_attendance_time') final String? lastAttendanceTime,
  }) = _$EmployeeEntityImpl;

  factory _EmployeeEntity.fromJson(Map<String, dynamic> json) =
      _$EmployeeEntityImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get email;
  @override
  @JsonKey(name: 'image_url')
  String? get imageUrl;
  @override
  @JsonKey(name: 'attendance_status')
  String? get attendanceStatus;
  @override
  @JsonKey(name: 'last_attendance_time')
  String? get lastAttendanceTime;

  /// Create a copy of EmployeeEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EmployeeEntityImplCopyWith<_$EmployeeEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
