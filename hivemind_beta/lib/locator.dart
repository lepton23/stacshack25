import 'package:what3words/what3words.dart';
import 'package:geolocator/geolocator.dart';


var api = What3WordsV3('7YGLQZ1W');

Future<String> _get3Words(Position location) async {
  Response<Location> w3words;
  w3words = await api.convertTo3wa(Coordinates(location.latitude, location.longitude)).execute();

  if (w3words.isSuccessful()) {
    return w3words.data()!.words;
  } else {
    return Future.error('Could not convert location to what3words.');
  }
}

/// Determine the current position of the device.
/// When the location services are not enabled or permissions
/// are denied, will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      
      /// request permissions
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  return await Geolocator.getCurrentPosition();
}


