import 'package:flutter/material.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/services/location_helper.dart';
import 'package:weather/services/network_helper.dart';
import 'package:weather/utils/constants.dart';

class WeatherHelper {
  Future<Weather> getCurrentLocationWeather() async {
    LocationHelper locationHelper = LocationHelper();
    Location location = await locationHelper.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$baseUrl?lat=${location.latitude}&lon=${location.longitude}&units=metric&appid=$apiKey');

    dynamic data = await networkHelper.getData();
    Weather weather = Weather.fromJson(location, data);
    return weather;
  }

  Future<Weather> getAddressWeather(String address) async {
    LocationHelper locationHelper = LocationHelper();
    Location location = await locationHelper.getLocationFromAddress(address);

    NetworkHelper networkHelper = NetworkHelper(
        '$baseUrl?lat=${location.latitude}&lon=${location.longitude}&units=metric&appid=$apiKey');

    dynamic data = await networkHelper.getData();
    Weather weather = Weather.fromJson(location, data);
    return weather;
  }

  Future<Weather> getCoordinatesWeather(double lat, double long) async {
    LocationHelper locationHelper = LocationHelper();
    Location location =
        await locationHelper.getLocationFromCoordinates(lat, long);

    NetworkHelper networkHelper = NetworkHelper(
        '$baseUrl?lat=${location.latitude}&lon=${location.longitude}&units=metric&appid=$apiKey');

    dynamic data = await networkHelper.getData();
    Weather weather = Weather.fromJson(location, data);
    return weather;
  }

  String getWeatherIcon(int condition) {
    //TODO: CHECK WEATHER CONDITION AND SHOW ICON
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'Hot';
    } else if (temp > 20) {
      return 'Warm';
    } else if (temp < 10) {
      return 'Cold';
    } else {
      return 'Freezing cold';
    }
  }

  Color getWeatherColor(int temp) {
    print(temp);
    if (temp > 30) {
      return Colors.redAccent;
    } else if (temp > 25) {
      return Colors.orangeAccent;
    } else if (temp > 20) {
      return Colors.amberAccent;
    } else if (temp > 10) {
      return Colors.lightBlueAccent;
    } else {
      return Colors.blueAccent;
    }
  }
}
