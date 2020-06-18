import 'package:flutter/material.dart';
import 'package:weather/models/location.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/services/location_helper.dart';
import 'package:weather/services/network_helper.dart';
import 'package:weather/utils/constants.dart';

class WeatherHelper {
  //This function gets a weather data from the API using current location's LAT & LONG coordinates
  Future<Weather> getCurrentLocationWeather() async {
    LocationHelper locationHelper = LocationHelper();
    Location location = await locationHelper.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$baseUrl/$apiKey/${location.latitude},${location.longitude}?units=si&exclude=minutely,hourly,flags');

    dynamic data = await networkHelper.getData();
    Weather weather = Weather.fromJson(location, data);
    return weather;
  }

  //This function gets a weather data from the API using provided address
  Future<Weather> getWeatherFromAddress(String address) async {
    LocationHelper locationHelper = LocationHelper();
    Location location = await locationHelper.getLocationFromAddress(address);

    NetworkHelper networkHelper = NetworkHelper(
        '$baseUrl/$apiKey/${location.latitude},${location.longitude}?units=si&exclude=minutely,hourly,flags');

    dynamic data = await networkHelper.getData();
    Weather weather = Weather.fromJson(location, data);
    return weather;
  }

  //This function gets a weather data from the API using provided LAT & LONG coordinates
  Future<Weather> getWeatherFromCoordinates(double lat, double long) async {
    LocationHelper locationHelper = LocationHelper();
    Location location =
        await locationHelper.getLocationFromCoordinates(lat, long);

    NetworkHelper networkHelper = NetworkHelper(
        '$baseUrl/$apiKey/${location.latitude},${location.longitude}?units=si&exclude=minutely,hourly,flags');

    dynamic data = await networkHelper.getData();
    Weather weather = Weather.fromJson(location, data);
    return weather;
  }

  //This function returns a color based on provided temperature.
  Color getWeatherColor(int temp) {
    if (temp > 30) {
      return Colors.redAccent;
    } else if (temp > 25) {
      return Colors.orangeAccent;
    } else if (temp > 18) {
      return Colors.amberAccent;
    } else if (temp > 10) {
      return Colors.lightBlueAccent;
    } else {
      return Colors.blueAccent;
    }
  }
}
