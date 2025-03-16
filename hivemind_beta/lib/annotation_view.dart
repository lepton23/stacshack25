import 'package:flutter/material.dart';
import 'annotation.dart';
import 'dart:math' as math;

class AnnotationView extends StatelessWidget {
  const AnnotationView({super.key, required this.annotation});

  final Annotation annotation;

  @override
  Widget build(BuildContext context) {
    // Calculate scale factor based on distance
    double scaleFactor = _calculateScaleFactor(annotation.distanceFromUser);

    return Transform.scale(
      scale: scaleFactor,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                annotation.message.body,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${annotation.distanceFromUser.toInt()} m',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  Icon(Icons.location_on, color: Colors.blue[300], size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateScaleFactor(double distance) {
    // Adjust these values to fine-tune the scaling
    const double minScale = 0.5;
    const double maxScale = 1.5;
    const double minDistance = 10.0; // meters
    const double maxDistance = 1000.0; // meters

    // Logarithmic scaling
    double scale = 1.0 - (math.log(distance) - math.log(minDistance)) / (math.log(maxDistance) - math.log(minDistance));
    return scale.clamp(minScale, maxScale);
  }
}

