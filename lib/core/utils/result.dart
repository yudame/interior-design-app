import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(String message, [Object? error]) = Failure<T>;
  const factory Result.loading() = Loading<T>;
}

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  bool get isLoading => this is Loading<T>;

  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        _ => null,
      };

  String? get errorMessage => switch (this) {
        Failure(:final message) => message,
        _ => null,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) failure,
    required R Function() loading,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      Failure(:final message, :final error) => failure(message, error),
      Loading() => loading(),
    };
  }

  R maybeWhen<R>({
    R Function(T data)? success,
    R Function(String message, Object? error)? failure,
    R Function()? loading,
    required R Function() orElse,
  }) {
    return switch (this) {
      Success(:final data) => success?.call(data) ?? orElse(),
      Failure(:final message, :final error) =>
        failure?.call(message, error) ?? orElse(),
      Loading() => loading?.call() ?? orElse(),
    };
  }
}
