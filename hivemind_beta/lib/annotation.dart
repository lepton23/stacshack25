import 'package:geolocator/geolocator.dart';
import 'package:ar_location_view/ar_location_view.dart';
import 'package:hivemind_beta/models/message.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class Annotation extends ArAnnotation {
  final Message message;
  
  Annotation({
    required super.uid, 
    required super.position, 
    required this.message,  
  });
}

// List<Annotation> fakeAnnotation({
//   required Position position,
//   int distance = 1500,
//   int numberMaxPoi = 100,
// }) {
//   return List<Annotation>.generate(
//     numberMaxPoi,
//     (index) {
//       return Annotation(
//         uid: const Uuid().v1(),
//         position: getRandomLocation(
//           position.latitude,
//           position.longitude,
//           distance / 100000,
//           distance / 100000,
//         ),
//         type: getRandomAnnotation(),
//       );
//     },
//   );
// }

Position getRandomLocation(double centerLatitude, double centerLongitude,
    double deltaLat, double deltaLon) {
  var lat = centerLatitude;
  var lon = centerLongitude;

  final latDelta = -(deltaLat / 2) + Random.secure().nextDouble() * deltaLat;
  final lonDelta = -(deltaLon / 2) + Random.secure().nextDouble() * deltaLon;
  lat = lat + latDelta;
  lon = lon + lonDelta;

  return Position(
    longitude: lon,
    latitude: lat,
    timestamp: DateTime.now(),
    accuracy: 1,
    altitude: 1,
    heading: 1,
    speed: 1,
    speedAccuracy: 1,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );
}
