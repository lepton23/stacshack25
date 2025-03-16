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
  Future <bool> userExists(String email) async {
    final user = await _firestore.collection('users').doc(email).get();
    return user.exists;
  }
  
  Future<void> addUser(String email) async {
    try {
      await _firestore.collection('users').doc(email).set({
        'email': email,
      });
    } catch (e) {
      print("Error adding user: $e");
      rethrow;
    }
  }
  Future<void> sendFriendRequest(String sender, String receiver) async {
    try {
      // Add request to sender's sent requests
      await _firestore.collection('users').doc(sender).update({
        'sentRequests': FieldValue.arrayUnion([receiver])
      });

      // Add request to receiver's received requests 
      await _firestore.collection('users').doc(receiver).update({
        'receivedRequests': FieldValue.arrayUnion([sender])
      });
    } catch (e) {
      print("Error sending friend request: $e");
      rethrow;
    }
  }

  Future<void> acceptFriendRequest(String sender, String receiver) async {
    try {
      // Add sender to receiver's friends
      await _firestore.collection('users').doc(receiver).update({
        'friends': FieldValue.arrayUnion([sender])
      });
    } catch (e) {
      print("Error accepting friend request: $e");
      rethrow;
    }
  }

  Future<void> declineFriendRequest(String sender, String receiver) async {
    try {
      // Remove request from sender's sent requests
      await _firestore.collection('users').doc(sender).update({
        'sentRequests': FieldValue.arrayRemove([receiver])
      });
    } catch (e) {
      print("Error declining friend request: $e");
      rethrow;
    }
  }

  Future<void> removeFriend(String email, String friend) async {
    try {
      // Remove friend from user's friends
      await _firestore.collection('users').doc(email).update({
        'friends': FieldValue.arrayRemove([friend])
      });
    } catch (e) {
      print("Error removing friend: $e");
      rethrow;
    }
  }

  Future<void> getFriends(String email) async {
    try {
      final user = await _firestore.collection('users').doc(email).get();
      return user.data()?['friends'] ?? [];
    } catch (e) {
      print("Error getting friends: $e");
      rethrow;
    }
  }

  Future<void> getSentRequests(String email) async {
    try {
      final user = await _firestore.collection('users').doc(email).get();
      return user.data()?['sentRequests'] ?? [];
    } catch (e) {
      print("Error getting sent requests: $e");
      rethrow;
    }
  }

  Future<List<String>> getReceivedRequests(String email) async {
    try {
      final user = await _firestore.collection('users').doc(email).get();
      final List<dynamic> receivedRequests = user.data()?['receivedRequests'] ?? [];
      return receivedRequests.map((e) => e.toString()).toList();
    } catch (e) {
      print("Error getting received requests: $e");
      rethrow;
    }
  }
}
