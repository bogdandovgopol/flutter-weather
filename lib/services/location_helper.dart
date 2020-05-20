import 'package:geolocator/geolocator.dart';
import 'package:weather/models/location.dart';

class LocationHelper {
  Future<Location> getCurrentLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      List<Placemark> placemarks =
          await Geolocator().placemarkFromPosition(position);
      Placemark placemark = placemarks[0];

      return Location(placemark.position.latitude, placemark.position.longitude,
          placemark.locality, placemark.country);
    } catch (e) {
      print(e);
    }
  }

  Future<Location> getLocationFromAddress(String address) async {
    try {
      List<Placemark> placemarks =
          await Geolocator().placemarkFromAddress(address);
      Placemark placemark = placemarks[0];

      return Location(placemark.position.latitude, placemark.position.longitude,
          placemark.locality, placemark.country);
    } catch (e) {}
  }

  Future<Location> getLocationFromCoordinates(double lat, double long) async {
    try {
      List<Placemark> placemarks =
          await Geolocator().placemarkFromCoordinates(lat, long);
      Placemark placemark = placemarks[0];

      return Location(placemark.position.latitude, placemark.position.longitude,
          placemark.locality, placemark.country);
    } catch (e) {}
  }
}
