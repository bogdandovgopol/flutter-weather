import 'location.dart';

class Weather {
  Location location;
  int temp;
  int condition;
  int pressure;
  int humidity;
  int windSpeed;

  Weather({
    this.location,
    this.temp,
    this.condition,
    this.pressure,
    this.humidity,
    this.windSpeed,
  });

  factory Weather.fromJson(Location location, dynamic json) {
    return Weather(
      location: location,
      temp: json['main']['temp'].floor(),
      condition: json['weather'][0]['id'],
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] * 3.6).floor(),
    );
  }
}
