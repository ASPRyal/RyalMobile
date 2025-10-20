// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FailureStatus {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) failure,
    required TResult Function() serverFailure,
    required TResult Function() noFailure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? failure,
    TResult? Function()? serverFailure,
    TResult? Function()? noFailure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? failure,
    TResult Function()? serverFailure,
    TResult Function()? noFailure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FailureStatusFailure value) failure,
    required TResult Function(_FailureStatusServerFailure value) serverFailure,
    required TResult Function(_FailureStatusNoFailure value) noFailure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FailureStatusFailure value)? failure,
    TResult? Function(_FailureStatusServerFailure value)? serverFailure,
    TResult? Function(_FailureStatusNoFailure value)? noFailure,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FailureStatusFailure value)? failure,
    TResult Function(_FailureStatusServerFailure value)? serverFailure,
    TResult Function(_FailureStatusNoFailure value)? noFailure,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureStatusCopyWith<$Res> {
  factory $FailureStatusCopyWith(
    FailureStatus value,
    $Res Function(FailureStatus) then,
  ) = _$FailureStatusCopyWithImpl<$Res, FailureStatus>;
}

/// @nodoc
class _$FailureStatusCopyWithImpl<$Res, $Val extends FailureStatus>
    implements $FailureStatusCopyWith<$Res> {
  _$FailureStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FailureStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FailureStatusFailureImplCopyWith<$Res> {
  factory _$$FailureStatusFailureImplCopyWith(
    _$FailureStatusFailureImpl value,
    $Res Function(_$FailureStatusFailureImpl) then,
  ) = __$$FailureStatusFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FailureStatusFailureImplCopyWithImpl<$Res>
    extends _$FailureStatusCopyWithImpl<$Res, _$FailureStatusFailureImpl>
    implements _$$FailureStatusFailureImplCopyWith<$Res> {
  __$$FailureStatusFailureImplCopyWithImpl(
    _$FailureStatusFailureImpl _value,
    $Res Function(_$FailureStatusFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FailureStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$FailureStatusFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$FailureStatusFailureImpl implements _FailureStatusFailure {
  const _$FailureStatusFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'FailureStatus.failure(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailureStatusFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of FailureStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FailureStatusFailureImplCopyWith<_$FailureStatusFailureImpl>
  get copyWith =>
      __$$FailureStatusFailureImplCopyWithImpl<_$FailureStatusFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) failure,
    required TResult Function() serverFailure,
    required TResult Function() noFailure,
  }) {
    return failure(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? failure,
    TResult? Function()? serverFailure,
    TResult? Function()? noFailure,
  }) {
    return failure?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? failure,
    TResult Function()? serverFailure,
    TResult Function()? noFailure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FailureStatusFailure value) failure,
    required TResult Function(_FailureStatusServerFailure value) serverFailure,
    required TResult Function(_FailureStatusNoFailure value) noFailure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FailureStatusFailure value)? failure,
    TResult? Function(_FailureStatusServerFailure value)? serverFailure,
    TResult? Function(_FailureStatusNoFailure value)? noFailure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FailureStatusFailure value)? failure,
    TResult Function(_FailureStatusServerFailure value)? serverFailure,
    TResult Function(_FailureStatusNoFailure value)? noFailure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _FailureStatusFailure implements FailureStatus {
  const factory _FailureStatusFailure(final String message) =
      _$FailureStatusFailureImpl;

  String get message;

  /// Create a copy of FailureStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FailureStatusFailureImplCopyWith<_$FailureStatusFailureImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$FailureStatusServerFailureImplCopyWith<$Res> {
  factory _$$FailureStatusServerFailureImplCopyWith(
    _$FailureStatusServerFailureImpl value,
    $Res Function(_$FailureStatusServerFailureImpl) then,
  ) = __$$FailureStatusServerFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FailureStatusServerFailureImplCopyWithImpl<$Res>
    extends _$FailureStatusCopyWithImpl<$Res, _$FailureStatusServerFailureImpl>
    implements _$$FailureStatusServerFailureImplCopyWith<$Res> {
  __$$FailureStatusServerFailureImplCopyWithImpl(
    _$FailureStatusServerFailureImpl _value,
    $Res Function(_$FailureStatusServerFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FailureStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FailureStatusServerFailureImpl implements _FailureStatusServerFailure {
  const _$FailureStatusServerFailureImpl();

  @override
  String toString() {
    return 'FailureStatus.serverFailure()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailureStatusServerFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) failure,
    required TResult Function() serverFailure,
    required TResult Function() noFailure,
  }) {
    return serverFailure();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? failure,
    TResult? Function()? serverFailure,
    TResult? Function()? noFailure,
  }) {
    return serverFailure?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? failure,
    TResult Function()? serverFailure,
    TResult Function()? noFailure,
    required TResult orElse(),
  }) {
    if (serverFailure != null) {
      return serverFailure();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FailureStatusFailure value) failure,
    required TResult Function(_FailureStatusServerFailure value) serverFailure,
    required TResult Function(_FailureStatusNoFailure value) noFailure,
  }) {
    return serverFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FailureStatusFailure value)? failure,
    TResult? Function(_FailureStatusServerFailure value)? serverFailure,
    TResult? Function(_FailureStatusNoFailure value)? noFailure,
  }) {
    return serverFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FailureStatusFailure value)? failure,
    TResult Function(_FailureStatusServerFailure value)? serverFailure,
    TResult Function(_FailureStatusNoFailure value)? noFailure,
    required TResult orElse(),
  }) {
    if (serverFailure != null) {
      return serverFailure(this);
    }
    return orElse();
  }
}

abstract class _FailureStatusServerFailure implements FailureStatus {
  const factory _FailureStatusServerFailure() =
      _$FailureStatusServerFailureImpl;
}

/// @nodoc
abstract class _$$FailureStatusNoFailureImplCopyWith<$Res> {
  factory _$$FailureStatusNoFailureImplCopyWith(
    _$FailureStatusNoFailureImpl value,
    $Res Function(_$FailureStatusNoFailureImpl) then,
  ) = __$$FailureStatusNoFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$FailureStatusNoFailureImplCopyWithImpl<$Res>
    extends _$FailureStatusCopyWithImpl<$Res, _$FailureStatusNoFailureImpl>
    implements _$$FailureStatusNoFailureImplCopyWith<$Res> {
  __$$FailureStatusNoFailureImplCopyWithImpl(
    _$FailureStatusNoFailureImpl _value,
    $Res Function(_$FailureStatusNoFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FailureStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$FailureStatusNoFailureImpl implements _FailureStatusNoFailure {
  const _$FailureStatusNoFailureImpl();

  @override
  String toString() {
    return 'FailureStatus.noFailure()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailureStatusNoFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) failure,
    required TResult Function() serverFailure,
    required TResult Function() noFailure,
  }) {
    return noFailure();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? failure,
    TResult? Function()? serverFailure,
    TResult? Function()? noFailure,
  }) {
    return noFailure?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? failure,
    TResult Function()? serverFailure,
    TResult Function()? noFailure,
    required TResult orElse(),
  }) {
    if (noFailure != null) {
      return noFailure();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FailureStatusFailure value) failure,
    required TResult Function(_FailureStatusServerFailure value) serverFailure,
    required TResult Function(_FailureStatusNoFailure value) noFailure,
  }) {
    return noFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FailureStatusFailure value)? failure,
    TResult? Function(_FailureStatusServerFailure value)? serverFailure,
    TResult? Function(_FailureStatusNoFailure value)? noFailure,
  }) {
    return noFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FailureStatusFailure value)? failure,
    TResult Function(_FailureStatusServerFailure value)? serverFailure,
    TResult Function(_FailureStatusNoFailure value)? noFailure,
    required TResult orElse(),
  }) {
    if (noFailure != null) {
      return noFailure(this);
    }
    return orElse();
  }
}

abstract class _FailureStatusNoFailure implements FailureStatus {
  const factory _FailureStatusNoFailure() = _$FailureStatusNoFailureImpl;
}
