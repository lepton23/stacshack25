import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:hivemind_beta/models/geo.dart';
import 'package:hivemind_beta/models/message.dart';

class FirebaseController {
  final _firestore = FirebaseFirestore.instance;
  static const String _geofield = 'geo';

  Future<void> addMessage(double latitude, double longitude, String body) async {
    try {
      // https://pub.dev/packages/geoflutterfire_plus
      final GeoFirePoint geoFirePoint = GeoFirePoint(GeoPoint(latitude, longitude));

      final message = Message(geo: Geo.fromGeoFirePoint(geoFirePoint), body: body, threeWords: "ABC");

      final docRef = await GeoCollectionReference<Map<String, dynamic>>(
        _firestore.collection('messages'),
      ).add(<String, dynamic>{
        _geofield: geoFirePoint.data,
        "body": body,
        "threeWords": "ABC",
        "timestamp": FieldValue.serverTimestamp(),
      });

      print("Document added with ID: ${docRef.id}");
    } catch (e) {
      print("Error adding message to Firebase: $e");
      // You might want to rethrow the error or handle it differently
      rethrow;
    }
  }

  Future<Stream<List<Message>>> getMessages(double latitude, double longitude, double radius) async {
    final GeoFirePoint center = GeoFirePoint(GeoPoint(latitude, longitude));
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

    return stream.map((List<DocumentSnapshot<Message>> event) => event.map((e) => e.data()!).toList());
  }
}
