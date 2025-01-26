import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mappls_gl/mappls_gl.dart';

Future<void> writeDataToFirestore(
    String collectionName, Map<String, dynamic> data) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    firestore.collection(collectionName).add(data);
    print('data added $data');
  } catch (e) {
    print('Error writing string to Firestore: $e');
  }
}

Future<void> bookACab(String phoneNumber, ReverseGeocodePlace origin,
    ReverseGeocodePlace destination, String fare, double distance) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var data = {
    'phoneNumber': phoneNumber,
    'distance': '${(distance / 1000).toStringAsFixed(2)} Km',
    'fare': fare,
    'pickupPoint': [origin.latitude, origin.longitude],
    'destinationPoint': [destination.latitude, destination.longitude],
    'pickupAddress': origin.formattedAddress,
    'destinationAddress': destination.formattedAddress
  };
  try {
    firestore.collection('currentRides').add(data);
    print('data added $data');
  } catch (e) {
    print('Error writing string to Firestore: $e');
  }
}
