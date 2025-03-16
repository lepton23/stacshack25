import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart' as flutter_compass;
import 'dart:math' as math;

class CompassDebug extends StatefulWidget {
  const CompassDebug({super.key});

  @override
  State<CompassDebug> createState() => _CompassDebugState();
}

class _CompassDebugState extends State<CompassDebug> {
  double _heading = 0;
  bool _hasCompass = false;
  String _compassError = '';

  @override
  void initState() {
    super.initState();
    _checkCompass();
  }

  void _checkCompass() async {
    // Check if compass is available on this device
    final hasCompass = await flutter_compass.FlutterCompass.events != null;
    
    if (mounted) {
      setState(() {
        _hasCompass = hasCompass;
        _compassError = hasCompass ? '' : 'Compass not available on this device';
      });
    }

    if (hasCompass) {
      flutter_compass.FlutterCompass.events?.listen((flutter_compass.CompassEvent event) {
        print('Raw compass event: $event'); // Debug print
        
        if (mounted) {
          setState(() {
            _heading = event.heading ?? 0;
            _compassError = event.headingForCameraMode != null
                ? ''
                : 'No camera heading available';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compass Debug'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_hasCompass)
              Text(
                'Compass not available on this device',
                style: TextStyle(color: Colors.red, fontSize: 18),
              )
            else if (_compassError.isNotEmpty)
              Text(
                _compassError,
                style: TextStyle(color: Colors.orange, fontSize: 18),
              )
            else
              Column(
                children: [
                  Text(
                    'Compass Heading: ${_heading.toStringAsFixed(1)}°',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Transform.rotate(
                    angle: (math.pi / 180) * _heading * -1,
                    child: Container(
                      width: 200,
                      height: 200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/compass.png',
                            width: 200,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey, width: 2),
                                ),
                                child: CustomPaint(
                                  painter: CompassPainter(),
                                ),
                              );
                            },
                          ),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _checkCompass();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Refreshing compass...')),
                );
              },
              child: Text('Refresh Compass'),
            )
          ],
        ),
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // North
    final northPaint = Paint()..color = Colors.red;
    canvas.drawLine(
      center,
      Offset(center.dx, center.dy - radius + 10),
      northPaint..strokeWidth = 5,
    );
    
    // South
    final southPaint = Paint()..color = Colors.grey;
    canvas.drawLine(
      center,
      Offset(center.dx, center.dy + radius - 10),
      southPaint..strokeWidth = 3,
    );
    
    // East
    final eastPaint = Paint()..color = Colors.grey;
    canvas.drawLine(
      center,
      Offset(center.dx + radius - 10, center.dy),
      eastPaint..strokeWidth = 3,
    );
    
    // West
    final westPaint = Paint()..color = Colors.grey;
    canvas.drawLine(
      center,
      Offset(center.dx - radius + 10, center.dy),
      westPaint..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
