import 'package:geolocator/geolocator.dart';

final LocationSettings locationSettings = LocationSettings(
  accuracy: LocationAccuracy.high,
  distanceFilter: 100,
);

Future<double> calculateDistance(double targetLatitude, double targetLongitude) async {
  // Get current location
  final currentLocation = await Geolocator.getCurrentPosition(settings: locationSettings);
  final currentLatitude = currentLocation.latitude;
  final currentLongitude = currentLocation.longitude;

  // Calculate distance using Haversine formula (more accurate for long distances)
  final distanceInMeters = await Geolocator.distanceBetween(
      currentLatitude, currentLongitude, targetLatitude, targetLongitude);

  // Convert meters to kilometers
  final distanceInKilometers = distanceInMeters / 1000.0;

  // Calculate halfway point distance (optional)
  final halfDistance = distanceInKilometers / 2.0;

  // Logic for waiting and recalculating distance (implementation depends on your app's logic)
  // ... (e.g., use a timer or a different event trigger)

  // Choose the distance based on your scenario:
  double distanceToUse;
  if (/* condition for waiting on current location */) {
    // Use halfway point distance if waiting
    distanceToUse = halfDistance;
  } else {
    // Use full distance if not waiting
    distanceToUse = distanceInKilometers;
  }

  return distanceToUse;
}
