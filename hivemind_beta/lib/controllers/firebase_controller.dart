import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:hivemind_beta/controllers/locator.dart';
import 'package:hivemind_beta/models/geo.dart';
import 'package:hivemind_beta/models/message.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'getWords.dart';

class FirebaseController {
  final _firestore = FirebaseFirestore.instance;
  static const String _geofield = 'geo';

  Future<void> addMessage(String body) async {
    try {
      final position = await determinePosition();
      final GeoFirePoint geoFirePoint = GeoFirePoint(GeoPoint(position.latitude, position.longitude));
      final fourWords = get4Words(position);

      final message = Message(
        geo: Geo.fromGeoFirePoint(geoFirePoint),
        body: body,
        fourWords: fourWords,
        comments: [],
        likes: 0,
        dislikes: 0,
      );

      final docRef = await GeoCollectionReference<Map<String, dynamic>>(
        _firestore.collection('messages'),
      ).add(message.toMap());

      print("Document added with ID: ${docRef.id}");
      print("Added message: ${message.toMap()}");
    } catch (e) {
      print("Error adding message to Firebase: $e");
      rethrow;
    }
  }

  Future<Stream<List<Message>>> getMessages(double radius) async {
    try {
      final canVibrate = await Haptics.canVibrate();
      
      print("Getting messages with radius: $radius km");
      final position = await determinePosition();
      print("Current position: ${position.latitude}, ${position.longitude}");
      final GeoFirePoint center = GeoFirePoint(GeoPoint(position.latitude, position.longitude));
      final typedCollectionReference = _firestore
          .collection('messages')
          .withConverter<Message>(
            fromFirestore: (ds, _) => Message.fromDocumentSnapshot(ds),
            toFirestore: (obj, _) => obj.toMap(),
          );

      GeoPoint geopointFrom(Message message) => message.geo.geopoint;

      final Stream<List<DocumentSnapshot<Message>>> stream = GeoCollectionReference<Message>(
        typedCollectionReference,
      ).subscribeWithin(center: center, radiusInKm: radius, field: _geofield, geopointFrom: geopointFrom);

      return stream.map((List<DocumentSnapshot<Message>> documents) {
        print("Received ${documents.length} documents");
        return documents.map((doc) {
          final message = doc.data()!;

          double lat = message.geo.geopoint.latitude;
          double lng = message.geo.geopoint.longitude;

          if (((lat - position.latitude).abs() >= 0.0001) || ((lng - position.longitude).abs() >= 0.0001)) {
            Haptics.vibrate(HapticsType.heavy);
          }

          print("Document ID: ${doc.id}");
          print("Message: ${message.body}");
          print("Location: ${message.geo.geopoint.latitude}, ${message.geo.geopoint.longitude}");
          print("Three Words: ${message.fourWords}");
          print("Likes: ${message.likes}, Dislikes: ${message.dislikes}");
          print("Comments: ${message.comments}");
          return message;
        }).toList();
      });
    } catch (e) {
      print("Error getting messages: $e");
      return Stream.value([]);
    }
  }
  Future <bool> userExists(String username) async {
    final user = await _firestore.collection('users').doc(username).get();
    return user.exists;
  }
  
  Future<void> addUser(String email, String username) async {
    try {
      await _firestore.collection('users').doc(email).set({
        'email': email,
        'username': username,
      });
    } catch (e) {
      print("Error adding user: $e");
      rethrow;
    }
  }
  

}
