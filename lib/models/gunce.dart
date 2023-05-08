import 'package:cloud_firestore/cloud_firestore.dart';

class Gunce {
  final String uid;
  //final String username;
  final String gunceID;
  final datePublished; // Düzenlenilecek
  final String gunceURL;
  //final String profImage;
  final likes;
  final viewList;
  final GeoPoint guncePosition;

  const Gunce({
    required this.uid,  
    //required this.username,
    required this.gunceID, 
    required this.datePublished,
    required this.gunceURL, 
    //required this.profImage,
    required this.likes,
    required this.viewList,
    required this.guncePosition,
    });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    //'username' : username,
    'gunceID': gunceID,
    'datePublished': datePublished,
    'gunceURL': gunceURL,
    //'profImage' : profImage,
    'likes' : likes,
    'viewList' : viewList,
    'guncePosition' : guncePosition,
  };
  static Gunce fromSnap (DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Gunce(
      uid : snapshot['uid'],
      //username : snapshot['username'],
      gunceID : snapshot['gunceID'],
      datePublished: snapshot['datePublished'],
      gunceURL : snapshot['gunceURL'],
      //profImage : snapshot['profImage'],
      likes : snapshot['postURL'],
      viewList: snapshot['viewList'],
      guncePosition: snapshot['guncePosition'],
    );
  }
  
}