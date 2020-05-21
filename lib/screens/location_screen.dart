import 'package:flutter/material.dart';
import 'package:weather/services/weather_helper.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.weather});

  final weather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: WeatherHelper().getWeatherColor(widget.weather.temp),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${widget.weather.temp}°',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 130,
                ),
              ),
              Text(
                '${widget.weather.location.city}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                ),
              ),
              Text(
                '${widget.weather.summary}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 35,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    weatherCard(
                      title: 'UV',
                      value: '${widget.weather.uvIndex}',
                    ),
                    weatherCard(
                      title: 'Humidity',
                      value: '${widget.weather.humidity}%',
                    ),
                    weatherCard(
                      title: 'Pressure',
                      value: '${widget.weather.pressure} hPa',
                    ),
                    weatherCard(
                      title: 'Wind',
                      value: '${widget.weather.windSpeed} km/h',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Card weatherCard({@required String title, @required String value}) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ));
  }
}
