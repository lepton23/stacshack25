import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class Geo {
  Geo({required this.geohash, required this.geopoint});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(geohash: json['geohash'] as String, geopoint: json['geopoint'] as GeoPoint);
  }

  factory Geo.fromGeoFirePoint(GeoFirePoint geoFirePoint) {
    final data = geoFirePoint.data;
    return Geo(geohash: data["geohash"], geopoint: data["geopoint"]);
  }

  final String geohash;
  final GeoPoint geopoint;

  Map<String, dynamic> toMap() => <String, dynamic>{'geohash': geohash, 'geopoint': geopoint};
}
