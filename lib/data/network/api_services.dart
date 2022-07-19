import 'dart:convert';

import '../model/weather_response.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  // location in Jakarta
  String endPoint = "http://api.openweathermap.org/data/2.5/onecall?lat=-6.175051064880487&lon=106.82753903587341&exclude=hourly,minutely&units=metric&APPID=36d045feeb2d3776a1e07c9c780517d7";
  Future<WeatherResponse> fetchWeather() async {

    final response = await http.get(Uri.parse(endPoint));
    final result = jsonDecode(response.body);
    return WeatherResponse.fromJson(result);
  }
}