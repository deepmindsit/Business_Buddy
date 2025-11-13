import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<String> updateUserLocation() async {
  String userLocation = '';

  LocationPermission permission = await Geolocator.requestPermission();
  print('permission==========>$permission');

  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    return '';
  }
  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print('position==========>$position');
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    print('placemarks==========>$placemarks');
    Placemark placemark = placemarks[0];

    if (placemarks.isNotEmpty) {
      userLocation =
          '${placemark.subLocality}, ${placemark.locality},';
    }
    return userLocation;
  } catch (e) {
    print('Error getting user location: $e');
  }
  return userLocation;
}
