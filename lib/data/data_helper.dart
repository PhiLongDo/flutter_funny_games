import 'dart:io';

import 'package:dio/dio.dart';

import 'models/app_result.dart';

ApiError parseApiException<T>(Exception ex) {
  switch (ex.runtimeType) {
    case DioError:
      {
        switch ((ex as DioError).error.runtimeType) {
          case SocketException:
            {
              return ApiError.networkError;
            }
          case HttpException:
            {
              return ApiError.serverError;
            }
          default:
            return ApiError.unknownError;
        }
      }
    case SocketException:
      {
        return ApiError.networkError;
      }
    case HttpException:
      {
        return ApiError.serverError;
      }
    default:
      return ApiError.unknownError;
  }
}
