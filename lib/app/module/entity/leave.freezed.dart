// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Leave _$LeaveFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'entity':
      return LeaveEntity.fromJson(json);
    case 'paramEntity':
      return LeaveParamEntity.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'Leave',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$Leave {
  @JsonKey(name: 'start_date')
  String get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  String get endDate => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
      String status,
      String? note,
    )
    entity,
    required TResult Function(
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
    )
    paramEntity,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
      String status,
      String? note,
    )?
    entity,
    TResult? Function(
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
    )?
    paramEntity,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
      String status,
      String? note,
    )?
    entity,
    TResult Function(
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
    )?
    paramEntity,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeaveEntity value) entity,
    required TResult Function(LeaveParamEntity value) paramEntity,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaveEntity value)? entity,
    TResult? Function(LeaveParamEntity value)? paramEntity,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaveEntity value)? entity,
    TResult Function(LeaveParamEntity value)? paramEntity,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this Leave to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Leave
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LeaveCopyWith<Leave> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaveCopyWith<$Res> {
  factory $LeaveCopyWith(Leave value, $Res Function(Leave) then) =
      _$LeaveCopyWithImpl<$Res, Leave>;
  @useResult
  $Res call({
    @JsonKey(name: 'start_date') String startDate,
    @JsonKey(name: 'end_date') String endDate,
    String reason,
  });
}

/// @nodoc
class _$LeaveCopyWithImpl<$Res, $Val extends Leave>
    implements $LeaveCopyWith<$Res> {
  _$LeaveCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Leave
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? reason = null,
  }) {
    return _then(
      _value.copyWith(
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as String,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as String,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LeaveEntityImplCopyWith<$Res>
    implements $LeaveCopyWith<$Res> {
  factory _$$LeaveEntityImplCopyWith(
    _$LeaveEntityImpl value,
    $Res Function(_$LeaveEntityImpl) then,
  ) = __$$LeaveEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'user_id') int userId,
    @JsonKey(name: 'start_date') String startDate,
    @JsonKey(name: 'end_date') String endDate,
    String reason,
    String status,
    String? note,
  });
}

/// @nodoc
class __$$LeaveEntityImplCopyWithImpl<$Res>
    extends _$LeaveCopyWithImpl<$Res, _$LeaveEntityImpl>
    implements _$$LeaveEntityImplCopyWith<$Res> {
  __$$LeaveEntityImplCopyWithImpl(
    _$LeaveEntityImpl _value,
    $Res Function(_$LeaveEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Leave
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? reason = null,
    Object? status = null,
    Object? note = freezed,
  }) {
    return _then(
      _$LeaveEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as String,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        note: freezed == note
            ? _value.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaveEntityImpl implements LeaveEntity {
  const _$LeaveEntityImpl({
    required this.id,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'start_date') required this.startDate,
    @JsonKey(name: 'end_date') required this.endDate,
    required this.reason,
    required this.status,
    this.note,
    final String? $type,
  }) : $type = $type ?? 'entity';

  factory _$LeaveEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaveEntityImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  @JsonKey(name: 'start_date')
  final String startDate;
  @override
  @JsonKey(name: 'end_date')
  final String endDate;
  @override
  final String reason;
  @override
  final String status;
  @override
  final String? note;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Leave.entity(id: $id, userId: $userId, startDate: $startDate, endDate: $endDate, reason: $reason, status: $status, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaveEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    startDate,
    endDate,
    reason,
    status,
    note,
  );

  /// Create a copy of Leave
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaveEntityImplCopyWith<_$LeaveEntityImpl> get copyWith =>
      __$$LeaveEntityImplCopyWithImpl<_$LeaveEntityImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
      String status,
      String? note,
    )
    entity,
    required TResult Function(
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
    )
    paramEntity,
  }) {
    return entity(id, userId, startDate, endDate, reason, status, note);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
      String status,
      String? note,
    )?
    entity,
    TResult? Function(
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
    )?
    paramEntity,
  }) {
    return entity?.call(id, userId, startDate, endDate, reason, status, note);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
      String status,
      String? note,
    )?
    entity,
    TResult Function(
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
    )?
    paramEntity,
    required TResult orElse(),
  }) {
    if (entity != null) {
      return entity(id, userId, startDate, endDate, reason, status, note);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeaveEntity value) entity,
    required TResult Function(LeaveParamEntity value) paramEntity,
  }) {
    return entity(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaveEntity value)? entity,
    TResult? Function(LeaveParamEntity value)? paramEntity,
  }) {
    return entity?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaveEntity value)? entity,
    TResult Function(LeaveParamEntity value)? paramEntity,
    required TResult orElse(),
  }) {
    if (entity != null) {
      return entity(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaveEntityImplToJson(this);
  }
}

abstract class LeaveEntity implements Leave {
  const factory LeaveEntity({
    required final int id,
    @JsonKey(name: 'user_id') required final int userId,
    @JsonKey(name: 'start_date') required final String startDate,
    @JsonKey(name: 'end_date') required final String endDate,
    required final String reason,
    required final String status,
    final String? note,
  }) = _$LeaveEntityImpl;

  factory LeaveEntity.fromJson(Map<String, dynamic> json) =
      _$LeaveEntityImpl.fromJson;

  int get id;
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  @JsonKey(name: 'start_date')
  String get startDate;
  @override
  @JsonKey(name: 'end_date')
  String get endDate;
  @override
  String get reason;
  String get status;
  String? get note;

  /// Create a copy of Leave
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaveEntityImplCopyWith<_$LeaveEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LeaveParamEntityImplCopyWith<$Res>
    implements $LeaveCopyWith<$Res> {
  factory _$$LeaveParamEntityImplCopyWith(
    _$LeaveParamEntityImpl value,
    $Res Function(_$LeaveParamEntityImpl) then,
  ) = __$$LeaveParamEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'start_date') String startDate,
    @JsonKey(name: 'end_date') String endDate,
    String reason,
  });
}

/// @nodoc
class __$$LeaveParamEntityImplCopyWithImpl<$Res>
    extends _$LeaveCopyWithImpl<$Res, _$LeaveParamEntityImpl>
    implements _$$LeaveParamEntityImplCopyWith<$Res> {
  __$$LeaveParamEntityImplCopyWithImpl(
    _$LeaveParamEntityImpl _value,
    $Res Function(_$LeaveParamEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Leave
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = null,
    Object? endDate = null,
    Object? reason = null,
  }) {
    return _then(
      _$LeaveParamEntityImpl(
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as String,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LeaveParamEntityImpl implements LeaveParamEntity {
  const _$LeaveParamEntityImpl({
    @JsonKey(name: 'start_date') required this.startDate,
    @JsonKey(name: 'end_date') required this.endDate,
    required this.reason,
    final String? $type,
  }) : $type = $type ?? 'paramEntity';

  factory _$LeaveParamEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$LeaveParamEntityImplFromJson(json);

  @override
  @JsonKey(name: 'start_date')
  final String startDate;
  @override
  @JsonKey(name: 'end_date')
  final String endDate;
  @override
  final String reason;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'Leave.paramEntity(startDate: $startDate, endDate: $endDate, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeaveParamEntityImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startDate, endDate, reason);

  /// Create a copy of Leave
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LeaveParamEntityImplCopyWith<_$LeaveParamEntityImpl> get copyWith =>
      __$$LeaveParamEntityImplCopyWithImpl<_$LeaveParamEntityImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
      String status,
      String? note,
    )
    entity,
    required TResult Function(
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
    )
    paramEntity,
  }) {
    return paramEntity(startDate, endDate, reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
      String status,
      String? note,
    )?
    entity,
    TResult? Function(
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
    )?
    paramEntity,
  }) {
    return paramEntity?.call(startDate, endDate, reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
      int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
      String status,
      String? note,
    )?
    entity,
    TResult Function(
      @JsonKey(name: 'start_date') String startDate,
      @JsonKey(name: 'end_date') String endDate,
      String reason,
    )?
    paramEntity,
    required TResult orElse(),
  }) {
    if (paramEntity != null) {
      return paramEntity(startDate, endDate, reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeaveEntity value) entity,
    required TResult Function(LeaveParamEntity value) paramEntity,
  }) {
    return paramEntity(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LeaveEntity value)? entity,
    TResult? Function(LeaveParamEntity value)? paramEntity,
  }) {
    return paramEntity?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeaveEntity value)? entity,
    TResult Function(LeaveParamEntity value)? paramEntity,
    required TResult orElse(),
  }) {
    if (paramEntity != null) {
      return paramEntity(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LeaveParamEntityImplToJson(this);
  }
}

abstract class LeaveParamEntity implements Leave {
  const factory LeaveParamEntity({
    @JsonKey(name: 'start_date') required final String startDate,
    @JsonKey(name: 'end_date') required final String endDate,
    required final String reason,
  }) = _$LeaveParamEntityImpl;

  factory LeaveParamEntity.fromJson(Map<String, dynamic> json) =
      _$LeaveParamEntityImpl.fromJson;

  @override
  @JsonKey(name: 'start_date')
  String get startDate;
  @override
  @JsonKey(name: 'end_date')
  String get endDate;
  @override
  String get reason;

  /// Create a copy of Leave
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LeaveParamEntityImplCopyWith<_$LeaveParamEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
