import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hivemind_beta/controllers/firebase_controller.dart';
import 'dart:math';

import 'package:hivemind_beta/controllers/locator.dart';
import 'package:hivemind_beta/models/message.dart';

class ARMessageViewer extends StatefulWidget {
  const ARMessageViewer({super.key});

  @override
  _ARMessageViewerState createState() => _ARMessageViewerState();
}

class _ARMessageViewerState extends State<ARMessageViewer> {
  final FirebaseController _firebaseController = FirebaseController();
  ArCoreController? arCoreController;
  Map<String, ArCoreNode> messageNodes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR Messages')),
      body: ArCoreView(onArCoreViewCreated: _onArCoreViewCreated, enableTapRecognizer: true),
      floatingActionButton: FloatingActionButton(onPressed: _refreshMessages, child: const Icon(Icons.refresh)),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    // Get your current position
    final currentPosition = await determinePosition();

    // Get all messages
    final messages = (await (await _firebaseController.getMessages(1)).toList()).fold<List<dynamic>>(
      [],
      (acc, e) => [...acc, ...e],
    );

    // Display messages that are within range
    for (var i = 0; i < messages.length; i++) {
      final message = messages[i];

      // Calculate distance between current position and message
      final distance = _calculateDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        message.coordinates.latitude,
        message.coordinates.longitude,
      );

      // Only show messages within 200 meters
      if (distance <= 200) {
        _createOrUpdateMessageNode(message, currentPosition, i.toString());
      }
    }
  }

  void _createOrUpdateMessageNode(Message message, Position currentPosition, String nodeId) {
    // Calculate relative position in 3D space
    final relativePosition = _calculateRelativePosition(
      currentPosition,
      Position(
        latitude: message.geo.geopoint.latitude,
        longitude: message.geo.geopoint.longitude,
        altitude: 1,
        speed: 1,
        speedAccuracy: 1,
        heading: 1,
        accuracy: 1,
        timestamp: DateTime.now(),
        headingAccuracy: 1,
        altitudeAccuracy: 1,
      ),
    );

    // If node already exists, remove it and create a new one
    if (messageNodes.containsKey(nodeId)) {
      arCoreController?.removeNode(nodeName: nodeId);
      if (messageNodes.containsKey("${nodeId}_text")) {
        arCoreController?.removeNode(nodeName: "${nodeId}_text");
      }
      messageNodes.remove(nodeId);
      messageNodes.remove("${nodeId}_text");
    }

    // Create message visualization
    final material = ArCoreMaterial(color: Colors.blue.withOpacity(0.8));
    final sphere = ArCoreSphere(materials: [material], radius: 0.1);

    final node = ArCoreNode(
      name: nodeId,
      shape: sphere,
      position: vector_math.Vector3(relativePosition.$1, relativePosition.$2, relativePosition.$3),
    );

    // Add node to the scene
    arCoreController?.addArCoreNode(node);
    messageNodes[nodeId] = node;

    // For the text, just use another sphere with different color as a simple solution
    final textNode = ArCoreNode(
      name: "${nodeId}_text",
      shape: ArCoreSphere(
        materials: [ArCoreMaterial(color: Colors.white)],
        radius: 0.05
      ),
      position: vector_math.Vector3(relativePosition.$1, relativePosition.$2 + 0.2, relativePosition.$3),
    );

    arCoreController?.addArCoreNode(textNode);
    messageNodes["${nodeId}_text"] = textNode;
  }

  (double, double, double) _calculateRelativePosition(Position userPosition, Position targetPosition) {
    // Calculate bearing and distance
    double bearing = _calculateBearing(
      userPosition.latitude,
      userPosition.longitude,
      targetPosition.latitude,
      targetPosition.longitude,
    );

    double distance = _calculateDistance(
      userPosition.latitude,
      userPosition.longitude,
      targetPosition.latitude,
      targetPosition.longitude,
    );

    // Scale distance for AR space (1 meter in real world = 0.1 units in AR)
    double scalingFactor = 0.1;
    double scaledDistance = distance * scalingFactor;

    // Convert to cartesian coordinates
    double x = scaledDistance * sin(bearing);
    double z = -scaledDistance * cos(bearing); // Negative because AR Z goes backward

    // Handle altitude if available
    double y = 0;
    double altitudeDifference = targetPosition.altitude - userPosition.altitude;
    y = altitudeDifference * scalingFactor;

    return (x, y, z);
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000; // Earth radius in meters
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final deltaPhi = (lat2 - lat1) * pi / 180;
    final deltaLambda = (lon2 - lon1) * pi / 180;

    final a =
        sin(deltaPhi / 2) * sin(deltaPhi / 2) + cos(phi1) * cos(phi2) * sin(deltaLambda / 2) * sin(deltaLambda / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distance in meters
  }

  double _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final lambda1 = lon1 * pi / 180;
    final lambda2 = lon2 * pi / 180;

    final y = sin(lambda2 - lambda1) * cos(phi2);
    final x = cos(phi1) * sin(phi2) - sin(phi1) * cos(phi2) * cos(lambda2 - lambda1);
    final bearing = atan2(y, x);

    return bearing;
  }

  void _refreshMessages() {
    // Clear existing messages
    messageNodes.forEach((id, node) {
      arCoreController?.removeNode(nodeName: id);
    });
    messageNodes.clear();

    // Load messages again
    _loadMessages();
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }
}
