import 'package:geolocator/geolocator.dart';

/// Determine the current position of the device.
/// When the location services are not enabled or permissions
/// are denied, will return an error.
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

  print('Getting a single, high-precision position sample...');

  try {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 10),
      ),
    );

    print('Position obtained:');
    print('  Latitude: ${position.latitude}');
    print('  Longitude: ${position.longitude}');
    print('  Accuracy: ${position.accuracy} meters');
    print('  Altitude: ${position.altitude} meters');
    print('  Speed: ${position.speed} m/s');
    print('  Heading: ${position.heading} degrees');
    print('  Timestamp: ${position.timestamp}');

    return position;
  } catch (e) {
    print('Error getting position: $e');
    return Future.error('Failed to get location: $e');
  }
}
