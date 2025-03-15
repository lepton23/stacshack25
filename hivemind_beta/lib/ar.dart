import 'package:flutter/material.dart';
import 'package:ar_location_view/ar_location_view.dart';
import 'annotation.dart';
import 'package:geolocator/geolocator.dart';

class ArView extends StatefulWidget {
  const ArView({super.key});

  @override
  State<ArView> createState() => _ArViewState();
}

class _ArViewState extends State<ArView> {
  List<Annotation> annotations = [];

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
              // annotations = fakeAnnotation(position: position, numberMaxPoi: 10);
              setState(() {});
            });
          },
        ),
      ),
    );
  }

