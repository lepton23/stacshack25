import 'package:flutter/material.dart';
import 'package:hivemind_beta/controllers/firebase_controller.dart';
import 'package:hivemind_beta/models/geo.dart';
import 'package:hivemind_beta/models/message.dart';

class FirebaseTest extends StatelessWidget {
  const FirebaseTest({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseController = FirebaseController();

    return Scaffold(
      appBar: AppBar(title: const Text('Firebase Test')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text("SEND MESSAGE"),
              onPressed: () {
                firebaseController.addMessage(45.268913, -66.054178, "Hello, World!");
              },
            ),
          ],
        ),
      ),
    );
  }
}

