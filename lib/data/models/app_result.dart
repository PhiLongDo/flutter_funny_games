class AppResult<T> {
  final ApiError? error;
  final ResultStatus? status;
  final T? data;

  AppResult(this.error, this.status, this.data);
}

enum ApiError { networkError, serverError, unknownError }

enum ResultStatus { success, failed, warning }
