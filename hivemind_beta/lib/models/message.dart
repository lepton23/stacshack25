import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hivemind_beta/models/geo.dart';

class Message {
  Message({
    required this.body,
    required this.geo,
    required this.threeWords,
    this.likes = 0,
    this.dislikes = 0,
    this.comments = const [],
  });

  final Geo geo;
  final String body;
  final String threeWords;
  int likes;
  int dislikes;
  List<String> comments;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'geo': geo.toMap(),
      'body': body,
      'threeWords': threeWords,
      'likes': likes,
      'dislikes': dislikes,
      'comments': comments,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      geo: Geo.fromJson(map['geo'] as Map<String, dynamic>),
      body: map['body'] as String,
      threeWords: map['threeWords'] as String,
      likes: map['likes'] as int? ?? 0,
      dislikes: map['dislikes'] as int? ?? 0,
      comments: List<String>.from(map['comments'] as List<dynamic>? ?? []),
    );
  }

  factory Message.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Message.fromMap(snapshot.data()! as Map<String, dynamic>);
  }
}
