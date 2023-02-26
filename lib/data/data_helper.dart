import 'dart:io';

import 'package:toss_coin/data/models/app_result.dart';

AppResult parseApiException(Exception ex) {
  var errorMessage = "";
  switch (ex.runtimeType) {
    case SocketException:
      {
        errorMessage = "Network error";
        break;
      }
    case HttpException:
      {
        errorMessage = "Services error";
        break;
      }
    default:
      errorMessage = "Unknown error";
  }

  return AppResult(errorMessage, ResultStatus.failed, null);
}
