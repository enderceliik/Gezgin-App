import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:yuruyus_app/resources/storage_methods.dart';

import '../models/gunce.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //Future<String> uploadGunce(Uint8List file, String uid, String username, String profImage) async {
    Future<String> uploadGunce(Uint8List file, Position guncePosition, String uid) async {
    String res = '';
    try
    {
      String photoURL = await StorageMethods().uploadImageToStorage('gunce', file, true);
      String gunceID = const Uuid().v1();
      Gunce gunce = Gunce(
        uid: uid,
        //username: username,
        datePublished: DateTime.now(),
        gunceURL: photoURL,
        //profImage: profImage,
        gunceID: gunceID,
        likes: [],
        viewList: [],
        guncePosition: GeoPoint(guncePosition.latitude, guncePosition.longitude), 
      );
      _firestore.collection('gunceRep').doc(gunceID).set(gunce.toJson(),);
      res = gunceID;
      _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'gunce': res});
    }
    catch(error)
    {
      res = 'Acces Denied';
      return res;
    }
    return res;
  }
}