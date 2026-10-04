// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AttendanceResponse _$AttendanceResponseFromJson(Map<String, dynamic> json) {
  return AttendanceResponseModel.fromJson(json);
}

/// @nodoc
mixin _$AttendanceResponse {
  AttendanceEntity? get today => throw _privateConstructorUsedError;
  @JsonKey(name: 'this_month')
  List<AttendanceEntity>? get thisMonth => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      AttendanceEntity? today,
      @JsonKey(name: 'this_month') List<AttendanceEntity>? thisMonth,
    )
    model,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      AttendanceEntity? today,
      @JsonKey(name: 'this_month') List<AttendanceEntity>? thisMonth,
    )?
    model,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      AttendanceEntity? today,
      @JsonKey(name: 'this_month') List<AttendanceEntity>? thisMonth,
    )?
    model,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AttendanceResponseModel value) model,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AttendanceResponseModel value)? model,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AttendanceResponseModel value)? model,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this AttendanceResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AttendanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AttendanceResponseCopyWith<AttendanceResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttendanceResponseCopyWith<$Res> {
  factory $AttendanceResponseCopyWith(
    AttendanceResponse value,
    $Res Function(AttendanceResponse) then,
  ) = _$AttendanceResponseCopyWithImpl<$Res, AttendanceResponse>;
  @useResult
  $Res call({
    AttendanceEntity? today,
    @JsonKey(name: 'this_month') List<AttendanceEntity>? thisMonth,
  });
}

/// @nodoc
class _$AttendanceResponseCopyWithImpl<$Res, $Val extends AttendanceResponse>
    implements $AttendanceResponseCopyWith<$Res> {
  _$AttendanceResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AttendanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? today = freezed, Object? thisMonth = freezed}) {
    return _then(
      _value.copyWith(
            today: freezed == today
                ? _value.today
                : today // ignore: cast_nullable_to_non_nullable
                      as AttendanceEntity?,
            thisMonth: freezed == thisMonth
                ? _value.thisMonth
                : thisMonth // ignore: cast_nullable_to_non_nullable
                      as List<AttendanceEntity>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AttendanceResponseModelImplCopyWith<$Res>
    implements $AttendanceResponseCopyWith<$Res> {
  factory _$$AttendanceResponseModelImplCopyWith(
    _$AttendanceResponseModelImpl value,
    $Res Function(_$AttendanceResponseModelImpl) then,
  ) = __$$AttendanceResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    AttendanceEntity? today,
    @JsonKey(name: 'this_month') List<AttendanceEntity>? thisMonth,
  });
}

/// @nodoc
class __$$AttendanceResponseModelImplCopyWithImpl<$Res>
    extends
        _$AttendanceResponseCopyWithImpl<$Res, _$AttendanceResponseModelImpl>
    implements _$$AttendanceResponseModelImplCopyWith<$Res> {
  __$$AttendanceResponseModelImplCopyWithImpl(
    _$AttendanceResponseModelImpl _value,
    $Res Function(_$AttendanceResponseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AttendanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? today = freezed, Object? thisMonth = freezed}) {
    return _then(
      _$AttendanceResponseModelImpl(
        today: freezed == today
            ? _value.today
            : today // ignore: cast_nullable_to_non_nullable
                  as AttendanceEntity?,
        thisMonth: freezed == thisMonth
            ? _value._thisMonth
            : thisMonth // ignore: cast_nullable_to_non_nullable
                  as List<AttendanceEntity>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AttendanceResponseModelImpl implements AttendanceResponseModel {
  _$AttendanceResponseModelImpl({
    this.today,
    @JsonKey(name: 'this_month')
    required final List<AttendanceEntity>? thisMonth,
  }) : _thisMonth = thisMonth;

  factory _$AttendanceResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttendanceResponseModelImplFromJson(json);

  @override
  final AttendanceEntity? today;
  final List<AttendanceEntity>? _thisMonth;
  @override
  @JsonKey(name: 'this_month')
  List<AttendanceEntity>? get thisMonth {
    final value = _thisMonth;
    if (value == null) return null;
    if (_thisMonth is EqualUnmodifiableListView) return _thisMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AttendanceResponse.model(today: $today, thisMonth: $thisMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttendanceResponseModelImpl &&
            const DeepCollectionEquality().equals(other.today, today) &&
            const DeepCollectionEquality().equals(
              other._thisMonth,
              _thisMonth,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(today),
    const DeepCollectionEquality().hash(_thisMonth),
  );

  /// Create a copy of AttendanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AttendanceResponseModelImplCopyWith<_$AttendanceResponseModelImpl>
  get copyWith =>
      __$$AttendanceResponseModelImplCopyWithImpl<
        _$AttendanceResponseModelImpl
      >(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      AttendanceEntity? today,
      @JsonKey(name: 'this_month') List<AttendanceEntity>? thisMonth,
    )
    model,
  }) {
    return model(today, thisMonth);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      AttendanceEntity? today,
      @JsonKey(name: 'this_month') List<AttendanceEntity>? thisMonth,
    )?
    model,
  }) {
    return model?.call(today, thisMonth);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      AttendanceEntity? today,
      @JsonKey(name: 'this_month') List<AttendanceEntity>? thisMonth,
    )?
    model,
    required TResult orElse(),
  }) {
    if (model != null) {
      return model(today, thisMonth);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AttendanceResponseModel value) model,
  }) {
    return model(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AttendanceResponseModel value)? model,
  }) {
    return model?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AttendanceResponseModel value)? model,
    required TResult orElse(),
  }) {
    if (model != null) {
      return model(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AttendanceResponseModelImplToJson(this);
  }
}

abstract class AttendanceResponseModel implements AttendanceResponse {
  factory AttendanceResponseModel({
    final AttendanceEntity? today,
    @JsonKey(name: 'this_month')
    required final List<AttendanceEntity>? thisMonth,
  }) = _$AttendanceResponseModelImpl;

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) =
      _$AttendanceResponseModelImpl.fromJson;

  @override
  AttendanceEntity? get today;
  @override
  @JsonKey(name: 'this_month')
  List<AttendanceEntity>? get thisMonth;

  /// Create a copy of AttendanceResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AttendanceResponseModelImplCopyWith<_$AttendanceResponseModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
