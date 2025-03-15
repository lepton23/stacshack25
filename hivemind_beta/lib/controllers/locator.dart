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

  print('Collecting multiple position samples for higher accuracy...');

  // Collect multiple samples
  List<Position> positions = [];
  const int sampleCount = 5;

  for (int i = 0; i < sampleCount; i++) {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          timeLimit: Duration(seconds: 5),
        ),
      );

      positions.add(position);
      print(
        'Sample ${i + 1}/$sampleCount: ${position.latitude}, ${position.longitude}, accuracy: ${position.accuracy} meters',
      );

      // Small delay between readings
      if (i < sampleCount - 1) {
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      print('Error getting position sample: $e');
    }
  }

  // Filter out low accuracy readings
  positions = positions.where((pos) => pos.accuracy < 20).toList();

  if (positions.isEmpty) {
    // Fall back to a single reading if all filtered out
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        timeLimit: Duration(seconds: 30), // Allow more time for a good fix
      ),
    );
  }

  // Sort by accuracy (lower is better)
  positions.sort((a, b) => a.accuracy.compareTo(b.accuracy));

  // Option 1: Just take the most accurate reading
  final mostAccurate = positions.first;

  // Option 2: Calculate average of top readings
  if (positions.length >= 3) {
    // Take top 3 most accurate readings
    final topPositions = positions.take(3).toList();

    double sumLat = 0, sumLng = 0, sumAcc = 0;
    for (var pos in topPositions) {
      sumLat += pos.latitude;
      sumLng += pos.longitude;
      sumAcc += pos.accuracy;
    }

    final avgPosition = Position(
      latitude: sumLat / topPositions.length,
      longitude: sumLng / topPositions.length,
      timestamp: DateTime.now(),
      accuracy: sumAcc / topPositions.length,
      altitude: topPositions.first.altitude,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
    );

    print(
      'Average position: ${avgPosition.latitude}, ${avgPosition.longitude}, estimated accuracy: ${avgPosition.accuracy} meters',
    );
    return avgPosition;
  }

  print(
    'Most accurate position: ${mostAccurate.latitude}, ${mostAccurate.longitude}, accuracy: ${mostAccurate.accuracy} meters',
  );
  return mostAccurate;
}
