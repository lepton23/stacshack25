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


