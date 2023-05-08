import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String username;
  final String name;
  final List followers;
  final List following;
  final List requests;
  final String team;
  final String gunce;
  final String profilePhotoURL;
  final double distance;

  const User({
    required this.uid, 
    required this.email, 
    required this.username,
    required this.name, 
    required this.followers,
    required this.following,
    required this.requests,
    required this.team,
    required this.gunce,
    required this.profilePhotoURL,
    required this.distance,

    });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'username' : username,
    'name' : name,
    'followers': followers,
    'following': following,
    'gunceS' : gunce,
    'profilePhotoURL': profilePhotoURL,
    'distance' : distance,
    'requests' : requests,
    'team' : team,
    //'type' : type,
    
  };
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String , dynamic>;
    return User(
      uid : snapshot['uid'],
      email : snapshot['uid'],
      username : snapshot['username'],
      name : snapshot['name'],
      followers : snapshot['followers'],
      following : snapshot['following'],
      requests: snapshot['requests'],
      team: snapshot['team'],
      gunce : snapshot['gunce'],
      profilePhotoURL : snapshot['uid'],
      distance : snapshot['distance'],
    );
  }
  
}

