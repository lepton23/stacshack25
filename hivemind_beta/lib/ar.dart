import 'package:flutter/material.dart';
import 'package:ar_location_view/ar_location_view.dart';
// import 'package:ar_location_viewer/ar_location_viewer.dart';
import 'annotation.dart';
import 'annotation_view.dart';
import 'package:geolocator/geolocator.dart';

class ArView extends StatefulWidget {
  const ArView({super.key});

  @override
  State<ArView> createState() => _ArViewState();
}

class _ArViewState extends State<ArView> {
  Position? _currentPos;
  List<Annotation> annotations = [];
  List<Annotation> _proximityAnnotations = [];
  final double proximityRadius = 10.0;

  @override
  void initState() {
    super.initState();

    annotations.add(
      Annotation(
        uid: "!@£!awc",
        position: Position(
        latitude: 56.3400687,
        longitude: -2.8094999,
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1,
        altitudeAccuracy: 0,
        headingAccuracy: 0,
        ),
        type: AnnotationType.message,
        message: "Tester tester 123",
      )
    );
  }

  void _checkProximity(Position currentPos) {
    annotations.forEach((annotation) {
      final distance = Geolocator.distanceBetween(
        currentPos.latitude,
        currentPos.longitude,
        annotation.position.latitude,
        annotation.position.longitude,
      );
      annotation.distanceFromUser = distance;

      if (distance <= proximityRadius) {
        _proximityAnnotations.add(annotation);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("You are near to ${annotation.message}"),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: "Close",
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        body: ArLocationWidget(
          annotations: annotations,
          showDebugInfoSensor: false,
          annotationWidth: 180,
          annotationHeight: 60,
          radarPosition: RadarPosition.bottomCenter,
          annotationViewBuilder: (context, annotation) {
            return AnnotationView(
              key: ValueKey(annotation.uid),
              annotation: annotation as Annotation,
            );
          }, 
          radarWidth: 160,
          scaleWithDistance: false,
          onLocationChange: (Position position) {
            Future.delayed(const Duration(seconds: 5), () {
              setState(() {
                _currentPos = position;
                _checkProximity(_currentPos as Position);
              });
            });
          },
        ),
      ),
    );
  
}
}