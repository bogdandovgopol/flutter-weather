import 'package:geolocator/geolocator.dart';
import 'package:weather/models/location.dart';

class LocationHelper {
  Future<Location> getCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    List<Placemark> placemarks =
        await Geolocator().placemarkFromPosition(position);
    Placemark placemark = placemarks[0];

    return Location(placemark.position.latitude, placemark.position.longitude,
        placemark.locality, placemark.country);
  }

  Future<Location> getLocationFromAddress(String address) async {
    List<Placemark> placemarks =
        await Geolocator().placemarkFromAddress(address);
    Placemark placemark = placemarks[0];

    return Location(placemark.position.latitude, placemark.position.longitude,
        placemark.locality, placemark.country);
  }

  Future<Location> getLocationFromCoordinates(double lat, double long) async {
    List<Placemark> placemarks =
        await Geolocator().placemarkFromCoordinates(lat, long);
    Placemark placemark = placemarks[0];

    return Location(placemark.position.latitude, placemark.position.longitude,
        placemark.locality, placemark.country);
  }
}
