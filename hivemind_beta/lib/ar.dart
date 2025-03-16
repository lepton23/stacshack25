import 'package:flutter/material.dart';
import 'package:ar_location_view/ar_location_view.dart';
import 'package:hivemind_beta/controllers/firebase_controller.dart';
import 'package:hivemind_beta/controllers/locator.dart';
import 'package:hivemind_beta/models/message.dart';
// import 'package:ar_location_viewer/ar_location_viewer.dart';
import 'annotation.dart';
import 'annotation_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class ArView extends StatefulWidget {
  const ArView({super.key});

  @override
  State<ArView> createState() => _ArViewState();
}

class _ArViewState extends State<ArView> {
  Position? _currentPos;
  final firebaseController = FirebaseController();
  List<Annotation> annotations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    Position pos = await determinePosition();
    setState(() {
      _currentPos = pos;
    });
    try {
      final messageStream = await firebaseController.getMessages(1);
      messageStream.listen(
        (List<Message> messages) {
          setState(() {
            annotations =
                messages
                    .map(
                      (message) => Annotation(
                        uid: message.id!,
                        message: message,
                        position: Position(
                          latitude: message.geo.geopoint.latitude,
                          longitude: message.geo.geopoint.longitude,
                          timestamp: DateTime.now(),
                          accuracy: 1,
                          altitude: 1,
                          heading: 1,
                          speed: 1,
                          speedAccuracy: 1,
                          altitudeAccuracy: 0,
                          headingAccuracy: 0,
                        ),
                      ),
                    )
                    .toList();
          });
        },
        onError: (error) {
          print('Error receiving messages: $error');
        },
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error setting up message stream: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : ArLocationWidget(
                  annotations: annotations,
                  showDebugInfoSensor: false,
                  // annotationWidth: 180,
                  // annotationHeight: 60,
                  radarPosition: RadarPosition.bottomCenter,
                  annotationViewBuilder: (context, annotation) {
                    return AnnotationView(key: ValueKey(annotation.uid), annotation: annotation as Annotation);
                  },
                  radarWidth: 160,
                  maxVisibleDistance: 80,
                  scaleWithDistance: true,
                  onLocationChange: (Position position) {
                    Future.delayed(const Duration(seconds: 5), () {
                      _currentPos = position;
                      Haptics.vibrate(HapticsType.error);
                      setState(() {});
                    });
                  },
                ),
      ),
    );
  }
}
