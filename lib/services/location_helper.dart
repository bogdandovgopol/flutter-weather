import 'package:geolocator/geolocator.dart';
import 'package:weather/models/location.dart';

class LocationHelper {
  //This function tries to get a CURRENT location and return the Location object
  Future<Location> getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    List<Placemark> placemarks =
        await Geolocator().placemarkFromPosition(position);
    Placemark placemark = placemarks[0];

    return Location(placemark.position.latitude, placemark.position.longitude,
        placemark.locality, placemark.country);
  }

  //This function tries to get a location using provided ADDRESS and return the Location object
  Future<Location> getLocationFromAddress(String address) async {
    List<Placemark> placemarks =
        await Geolocator().placemarkFromAddress(address);
    Placemark placemark = placemarks[0];

    return Location(placemark.position.latitude, placemark.position.longitude,
        placemark.locality, placemark.country);
  }

  //This function tries to get a location using provided LAT & LONG coordinates and return the Location object
  Future<Location> getLocationFromCoordinates(double lat, double long) async {
    List<Placemark> placemarks =
        await Geolocator().placemarkFromCoordinates(lat, long);
    Placemark placemark = placemarks[0];

    return Location(placemark.position.latitude, placemark.position.longitude,
        placemark.locality, placemark.country);
  }
}
