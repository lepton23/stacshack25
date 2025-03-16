import 'package:flutter/material.dart';
import 'package:hivemind_beta/controllers/firebase_controller.dart';

import 'package:hivemind_beta/models/message.dart';

class FirebaseTest extends StatefulWidget {
  const FirebaseTest({super.key});

  @override
  State<FirebaseTest> createState() => _FirebaseTestState();
}

class _FirebaseTestState extends State<FirebaseTest> {
  final FirebaseController firebaseController = FirebaseController();
  late Future<Stream<List<Message>>> messagesStreamFuture;

  @override
  void initState() {
    super.initState();
    _refreshMessages();
  }

  void _refreshMessages() {
    setState(() {
      messagesStreamFuture = firebaseController.getMessages(1.0); // 1km radius
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Test'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                child: Text("SEND MESSAGE"),
                onPressed: () {
                  firebaseController.addMessage("Hello, World!");
                },
              ),
              ElevatedButton(
                onPressed: _refreshMessages,
                child: Text("REFRESH"),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<Stream<List<Message>>>(
              future: messagesStreamFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('No messages stream available'));
                } else {
                  return StreamBuilder<List<Message>>(
                    stream: snapshot.data!,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No messages found'));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final message = snapshot.data![index];
                            return ListTile(
                              title: Text(message.body),
                              subtitle: Text(
                                '${message.fourWords} - ${message.geo.geopoint.latitude}, ${message.geo.geopoint.longitude}',
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
