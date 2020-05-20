import 'location.dart';

class Weather {
  Location location;
  int temp;
  int condition;

  Weather({
    this.location,
    this.temp,
    this.condition,
  });

  factory Weather.fromJson(Location location, dynamic json) {
    try {
      int cond = json['weather'][0]['id'];
    } catch (e) {
      print(e);
    }
    return Weather(
      location: location,
      temp: json['main']['temp'].floor(),
      condition: json['weather'][0]['id'],
    );
  }
}
