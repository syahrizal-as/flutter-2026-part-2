// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'holiday.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Holiday _$HolidayFromJson(Map<String, dynamic> json) {
  return HolidayEntity.fromJson(json);
}

/// @nodoc
mixin _$Holiday {
  String get date => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isNational => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String date, String name, bool isNational) entity,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String date, String name, bool isNational)? entity,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String date, String name, bool isNational)? entity,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HolidayEntity value) entity,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HolidayEntity value)? entity,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HolidayEntity value)? entity,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this Holiday to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Holiday
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HolidayCopyWith<Holiday> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HolidayCopyWith<$Res> {
  factory $HolidayCopyWith(Holiday value, $Res Function(Holiday) then) =
      _$HolidayCopyWithImpl<$Res, Holiday>;
  @useResult
  $Res call({String date, String name, bool isNational});
}

/// @nodoc
class _$HolidayCopyWithImpl<$Res, $Val extends Holiday>
    implements $HolidayCopyWith<$Res> {
  _$HolidayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Holiday
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? name = null,
    Object? isNational = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            isNational: null == isNational
                ? _value.isNational
                : isNational // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HolidayEntityImplCopyWith<$Res>
    implements $HolidayCopyWith<$Res> {
  factory _$$HolidayEntityImplCopyWith(
    _$HolidayEntityImpl value,
    $Res Function(_$HolidayEntityImpl) then,
  ) = __$$HolidayEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, String name, bool isNational});
}

/// @nodoc
class __$$HolidayEntityImplCopyWithImpl<$Res>
    extends _$HolidayCopyWithImpl<$Res, _$HolidayEntityImpl>
    implements _$$HolidayEntityImplCopyWith<$Res> {
  __$$HolidayEntityImplCopyWithImpl(
    _$HolidayEntityImpl _value,
    $Res Function(_$HolidayEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Holiday
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? name = null,
    Object? isNational = null,
  }) {
    return _then(
      _$HolidayEntityImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        isNational: null == isNational
            ? _value.isNational
            : isNational // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HolidayEntityImpl implements HolidayEntity {
  const _$HolidayEntityImpl({
    required this.date,
    required this.name,
    this.isNational = true,
  });

  factory _$HolidayEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$HolidayEntityImplFromJson(json);

  @override
  final String date;
  @override
  final String name;
  @override
  @JsonKey()
  final bool isNational;

  @override
  String toString() {
    return 'Holiday.entity(date: $date, name: $name, isNational: $isNational)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HolidayEntityImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isNational, isNational) ||
                other.isNational == isNational));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date, name, isNational);

  /// Create a copy of Holiday
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HolidayEntityImplCopyWith<_$HolidayEntityImpl> get copyWith =>
      __$$HolidayEntityImplCopyWithImpl<_$HolidayEntityImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String date, String name, bool isNational) entity,
  }) {
    return entity(date, name, isNational);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String date, String name, bool isNational)? entity,
  }) {
    return entity?.call(date, name, isNational);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String date, String name, bool isNational)? entity,
    required TResult orElse(),
  }) {
    if (entity != null) {
      return entity(date, name, isNational);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HolidayEntity value) entity,
  }) {
    return entity(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HolidayEntity value)? entity,
  }) {
    return entity?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HolidayEntity value)? entity,
    required TResult orElse(),
  }) {
    if (entity != null) {
      return entity(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$HolidayEntityImplToJson(this);
  }
}

abstract class HolidayEntity implements Holiday {
  const factory HolidayEntity({
    required final String date,
    required final String name,
    final bool isNational,
  }) = _$HolidayEntityImpl;

  factory HolidayEntity.fromJson(Map<String, dynamic> json) =
      _$HolidayEntityImpl.fromJson;

  @override
  String get date;
  @override
  String get name;
  @override
  bool get isNational;

  /// Create a copy of Holiday
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HolidayEntityImplCopyWith<_$HolidayEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
