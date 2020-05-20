import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/services/weather_helper.dart';

import 'location_screen.dart';

const apiKey = '44d0d14f66af51d18939b280758d7eec';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  //Variables
  final locationSearchTxtController = TextEditingController();
  SharedPreferences prefs;
  List<dynamic> locations = [];
  var currentLocationWeatherData;
  Future<Weather> currentWeather;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentWeatherData();
    loadLocations();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    locationSearchTxtController.dispose();
    super.dispose();
  }

  void loadLocations() async {
    prefs = await SharedPreferences.getInstance();
    this.locations = jsonDecode(prefs.getString('locations'));
  }

  void getCurrentWeatherData() async {
    currentWeather = WeatherHelper().getCurrentLocationWeather();
  }

  void saveLocation(String address) async {
    Weather weather = await WeatherHelper().getAddressWeather(address);
    this.locations.add(
        {'lat': weather.location.latitude, 'long': weather.location.longitude});

//    prefs.setString('locations', jsonEncode([]));
    prefs.setString('locations', jsonEncode(locations));

    //Reload listview
    setState(() {
      getWeatherList();
    });
  }

  Future<List<Weather>> getWeatherList() async {
    dynamic locations = jsonDecode(prefs.getString('locations'));
    List<Weather> weatherList = [];

    for (var location in locations) {
      Weather weather = await WeatherHelper()
          .getCoordinatesWeather(location['lat'], location['long']);
      weatherList.add(weather);
    }

    return weatherList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(15, 30, 15, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  searchButton(),
                  SizedBox(
                    width: 10,
                  ),
                  searchInput()
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Text(
                'Current Location',
              ),
            ),
            FutureBuilder(
              future: currentWeather,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationScreen(
                            locationWeather: snapshot.data,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
                      height: 120,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: WeatherHelper().getWeatherColor(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data.location.city,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data.location.country
                                            .toString()
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    '${snapshot.data.temp}°',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Container(
              child: Text(
                'Added Locations',
              ),
            ),
            FutureBuilder(
              future: getWeatherList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount:
                          snapshot.data == null ? 0 : snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: locationItem(snapshot.data, index),
                          onTap: () {
//                            print(locations[index]['city'] + ' clicked');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationScreen(
                                  locationWeather: snapshot.data[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Container searchButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Color(0xFFF2F2F2)),
      child: IconButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          Icons.add,
          color: Colors.black54,
        ),
        color: Colors.red,
        onPressed: () {
//          setState(() {
//            saveLocation(locationSearchTxtController.text);
//          });
          saveLocation(locationSearchTxtController.text);
        },
      ),
    );
  }

  Expanded searchInput() {
    return Expanded(
        child: Container(
      height: 50,
      child: TextField(
        controller: locationSearchTxtController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF2F2F2),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          hintText: 'Address...',
//                      onSubmitted: (String place) {},
        ),
      ),
    ));
  }

  Container locationItem(List<Weather> weather, int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
      height: 120,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: WeatherHelper().getWeatherColor(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        weather[index].location.city,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        weather[index].location.country,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Text(
                    weather[index].temp.toString(),
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
