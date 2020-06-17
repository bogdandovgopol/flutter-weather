import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/models/weather.dart';
import 'package:weather/services/weather_helper.dart';

import 'location_screen.dart';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  //Variables
  final locationSearchTxtController = TextEditingController();
  SharedPreferences prefs;
  List<dynamic> locations = [];
  Future<Weather> currentWeather;
  Future<List<Weather>> weatherList;

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

    //Reload listview
    setState(() {
      weatherList = getWeatherList();
    });
  }

  void getCurrentWeatherData() async {
    currentWeather = WeatherHelper().getCurrentLocationWeather();
  }

  void saveLocation(String address) async {
    if (locationSearchTxtController.text.isEmpty) {
      showAlert("Error adding location", "Location field is empty");
      return;
    }

    try {
      Weather weather = await WeatherHelper().getWeatherFromAddress(address);
      this.locations.add({
        'lat': weather.location.latitude,
        'long': weather.location.longitude
      });

      prefs.setString('locations', jsonEncode(locations));

      //Reload listview
      setState(() {
        weatherList = getWeatherList();
      });
    } catch (e) {
      showAlert("Error saving location",
          "Entered location probably does not exist, or you haven't given location permission.");
    }
  }

  Future<List<Weather>> getWeatherList() async {
    List<Weather> weatherList = [];
    for (var location in locations) {
      Weather weather = await WeatherHelper()
          .getWeatherFromCoordinates(location['lat'], location['long']);
      weatherList.add(weather);
    }

    if (weatherList.isNotEmpty)
      return weatherList;
    else
      return null;
  }

  void showAlert(String title, String content) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(title),
            content: new Text(content),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    //Allow portrait mode only
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //Change color of statusbar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        // To make Status bar icons color white in Android devices.
        statusBarIconBrightness: Brightness.dark,
        // statusBarBrightness is used to set Status bar icon color in iOS.
        statusBarBrightness: Brightness.light));

    return GestureDetector(
      onTap: () {
        //Hide keyboard on tap outside
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.fromLTRB(15, 0, 15, 5),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 5),
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 18),
                    child: Text(
                      'Current Location',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black26,
                          fontWeight: FontWeight.w500),
                    ),
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
                                weather: snapshot.data,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 120,
                          child: Card(
                            shadowColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: WeatherHelper()
                                .getWeatherColor(snapshot.data.temp),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 40, 20, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.location.city
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            snapshot.data.location.country,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        '${snapshot.data.temp}°',
                                        style: TextStyle(
                                          fontSize: 45,
                                          fontWeight: FontWeight.normal,
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
                      return SpinKitPulse(
                        color: Colors.lightBlueAccent,
                        size: 70.0,
                      );
                    }
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(5, 30, 0, 18),
                    child: Text(
                      'Added Locations',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black26,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                FutureBuilder(
                  future: weatherList,
                  // ignore: missing_return
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.done:
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data == null
                                ? 0
                                : snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                child: locationItem(snapshot.data, index),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LocationScreen(
                                        weather: snapshot.data[index],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                        break;
                      case ConnectionState.none:
                        return Container(
                          child: Text('List is empty'),
                        );
                        break;
                      case ConnectionState.waiting:
                        return SpinKitPulse(
                          color: Colors.lightBlueAccent,
                          size: 70.0,
                        );
                        break;
                      case ConnectionState.active:
                        return SpinKitPulse(
                          color: Colors.lightBlueAccent,
                          size: 70.0,
                        );
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
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
          Icons.arrow_back,
          color: Color(0xff8F8F8F),
        ),
        color: Colors.red,
        onPressed: () {
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
        onSubmitted: (value) {
          saveLocation(value);
        },
        controller: locationSearchTxtController,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF2F2F2),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xff8F8F8F),
          ),
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
        ),
      ),
    ));
  }

  Column locationItem(List<Weather> weather, int index) {
    return Column(
      children: <Widget>[
        Container(
          height: 120,
          child: Card(
            shadowColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: WeatherHelper().getWeatherColor(weather[index].temp),
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
                            weather[index].location.city.toUpperCase(),
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            weather[index].location.country,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      Text(
                        '${weather[index].temp.toString()}°',
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.normal,
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
        SizedBox(
          height: 5,
        )
      ],
    );
  }
}
