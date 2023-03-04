import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/response_models/task_reponse.dart';

part 'api.g.dart';

const baseUrl = "https://5d42a6e2bc64f90014a56ca0.mockapi.io/api/v1/";

@RestApi(baseUrl: baseUrl)
abstract class AppApi {
  factory AppApi(Dio dio, {String baseUrl}) = _AppApi;

  @GET("/tasks")
  Future<List<TaskReposeModel>> getTasks();
}

// class DefaultApi extends AppApi{}
