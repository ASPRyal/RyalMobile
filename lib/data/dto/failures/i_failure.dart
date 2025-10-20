abstract class IFailure {
  IFailure({
    String? message = '',
  }) : message = message!;

  final String message;
}
