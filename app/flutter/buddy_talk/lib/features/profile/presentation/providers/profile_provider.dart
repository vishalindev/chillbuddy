import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ProfileProvider extends ChangeNotifier {
  String name = 'Buddy User';
  String bio = 'Language enthusiast';
  String place = 'Unknown';
  String state = 'Unknown';
  String country = 'Unknown';
  String mapData = 'Lat/Lng unavailable';
  bool loadingLocation = false;
  String? locationError;

  Future<void> fetchCurrentLocationDetails() async {
    loadingLocation = true;
    locationError = null;
    notifyListeners();

    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        locationError = 'Location service disabled.';
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        locationError = 'Location permission not granted.';
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      mapData = 'Lat: ${position.latitude.toStringAsFixed(5)}, Lng: ${position.longitude.toStringAsFixed(5)}';
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        place = p.locality?.isNotEmpty == true ? p.locality! : (p.subAdministrativeArea ?? 'Unknown');
        state = p.administrativeArea ?? 'Unknown';
        country = p.country ?? 'Unknown';
      }
    } catch (e) {
      locationError = 'Unable to fetch location: $e';
    } finally {
      loadingLocation = false;
      notifyListeners();
    }
  }
}
