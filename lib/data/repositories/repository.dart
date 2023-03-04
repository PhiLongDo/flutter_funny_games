import 'package:dio/dio.dart';

import '../data_helper.dart';
import '../models/app_result.dart';
import '../models/response_models/task_reponse.dart';
import '../sources/remote/api.dart';

abstract class AppRepository {
  Future<AppResult<List<TaskReposeModel>>> getTasks();
}

class DefaultRepository extends AppRepository {
  static final DefaultRepository _instance = DefaultRepository._internal();

  factory DefaultRepository() => _instance;

  DefaultRepository._internal();

  final appApi = AppApi(Dio());

  @override
  Future<AppResult<List<TaskReposeModel>>> getTasks() async {
    List<TaskReposeModel>? data;
    ApiError? error;
    ResultStatus status = ResultStatus.warning;
    try {
      data = await appApi.getTasks();
      status = ResultStatus.success;
    } on Exception catch (ex) {
      status = ResultStatus.failed;
      error = parseApiException(ex);
    }
    return AppResult(error, status, data);
  }
}
