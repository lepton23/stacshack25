import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hivemind_beta/models/geo.dart';

class Message {
  final Geo geo;
  final String body;
  final String fourWords;
  final List<String> comments;
  final int likes;
  final int dislikes;

  Message({
    required this.geo,
    required this.body,
    required this.fourWords,
    this.comments = const [],
    this.likes = 0,
    this.dislikes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'geo': geo.toMap(),
      'body': body,
      'fourWords': fourWords,
      'comments': comments,
      'likes': likes,
      'dislikes': dislikes,
    };
  }

  static Message fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Message(
      geo: Geo.fromMap(data['geo'] as Map<String, dynamic>),
      body: data['body'] as String,
      fourWords: data['fourWords'] as String,
      comments: List<String>.from(data['comments'] ?? []),
      likes: data['likes'] as int? ?? 0,
      dislikes: data['dislikes'] as int? ?? 0,
    );
  }
}
