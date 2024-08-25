import 'package:dartz/dartz.dart';
import 'package:flutter_tutorial/data/api/api_endpoints.dart';
import 'package:flutter_tutorial/data/http_helper.dart';

abstract class WeatherRepo {
  ///
  static Future<Either<FailureModel, Map<dynamic, dynamic>>>
      getWeatherAtLocation() async {
    //
    return await HttpHelper.handleRequest((token) async {
      //
      return await HttpHelper.getData(
          linkUrl: WeatherApi.baseUrl, token: token);
    });

    //
  }

  //
}
