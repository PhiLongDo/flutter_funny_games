class AppResult<T> {
  final String? message;
  final ResultStatus? status;
  final T? data;

  AppResult(this.message, this.status, this.data);
}

enum ResultStatus { success, failed, warning }
