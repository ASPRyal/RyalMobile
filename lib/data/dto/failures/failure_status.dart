import 'package:freezed_annotation/freezed_annotation.dart';
part 'failure_status.freezed.dart';

@freezed
class FailureStatus with _$FailureStatus {
  const factory FailureStatus.failure(String message) = _FailureStatusFailure;
  const factory FailureStatus.serverFailure() = _FailureStatusServerFailure;
  const factory FailureStatus.noFailure() = _FailureStatusNoFailure;
}
