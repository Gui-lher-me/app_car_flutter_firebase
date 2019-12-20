import 'package:geolocator/geolocator.dart';

class GetLocation {

  Future<String> getLatitude()async {
    String latitude;
    await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).then((loc) {
      latitude = loc.latitude.toString();
    });
    return latitude;
  }

  Future<String> getLongitude()async {
    String longitude;
    await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation).then((loc) {
      longitude = loc.longitude.toString();
    });
    return longitude;
  }

}
