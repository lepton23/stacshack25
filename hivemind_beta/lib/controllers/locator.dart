import 'package:geolocator/geolocator.dart';
import 'dart:async';

/// Determine the current position of the device with maximum possible accuracy.
/// This function attempts to get a highly accurate GPS fix using high-precision
/// location permissions and multiple samples.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  print('Attempting to get a high-precision position fix...');

  try {
    // Request high-precision location updates
    const LocationSettings locationSettings = LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 0);

    // Get multiple position samples
    const int sampleCount = 5;
    const Duration sampleInterval = Duration(milliseconds: 500);
    List<Position> positions = [];

    for (int i = 0; i < sampleCount; i++) {
      print('Getting sample ${i + 1} of $sampleCount...');
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best, timeLimit: Duration(seconds: 2)),
        forceAndroidLocationManager: true,
      );
      positions.add(position);
      if (i < sampleCount - 1) {
        await Future.delayed(sampleInterval);
      }
    }

    // Calculate the average position
    double sumLat = 0, sumLon = 0, sumAlt = 0;
    double bestAccuracy = double.infinity;
    for (var pos in positions) {
      sumLat += pos.latitude;
      sumLon += pos.longitude;
      sumAlt += pos.altitude;
      if (pos.accuracy < bestAccuracy) {
        bestAccuracy = pos.accuracy;
      }
    }

    Position averagePosition = Position(
      latitude: sumLat / sampleCount,
      longitude: sumLon / sampleCount,
      timestamp: DateTime.now(),
      accuracy: bestAccuracy,
      altitude: sumAlt / sampleCount,
      heading: positions.last.heading,
      speed: positions.last.speed,
      speedAccuracy: positions.last.speedAccuracy,
      headingAccuracy: positions.last.headingAccuracy,
      altitudeAccuracy: positions.last.altitudeAccuracy,
    );

    print('High-precision position obtained:');
    print('  Latitude: ${averagePosition.latitude}');
    print('  Longitude: ${averagePosition.longitude}');
    print('  Accuracy: ${averagePosition.accuracy} meters');
    print('  Altitude: ${averagePosition.altitude} meters');
    print('  Timestamp: ${averagePosition.timestamp}');

    return averagePosition;
  } catch (e) {
    print('Error getting position: $e');
    return Future.error('Failed to get location: $e');
  }
}
