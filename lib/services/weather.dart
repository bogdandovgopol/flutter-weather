import 'package:flutter/material.dart';

class WeatherModel {
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
    if (temp > 25) {
      return Colors.redAccent;
    } else if (temp > 20) {
      return Colors.orangeAccent;
    } else if (temp < 10) {
      return Colors.lightBlueAccent;
    } else {
      return Colors.blueAccent;
    }
  }
}
