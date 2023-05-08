import 'package:cloud_firestore/cloud_firestore.dart';

class team {
  final String teamUID;
  final String teamName;
  final String teamPhotoURL;
  final String teamLeaderUID;
  final List teamWaitList;
  final List teamMemberList;

  const team({
    required this.teamUID,
    required this.teamName,
    required this.teamPhotoURL,
    required this.teamLeaderUID,
    required this.teamWaitList,
    required this.teamMemberList,
    });

  Map<String, dynamic> toJson() => {
    'teamUID' : teamUID,
    'teamName' : teamName,
    'teamPhotoURL' : teamPhotoURL,
    'teamLeaderUID' : teamLeaderUID,
    'teamWaitList' : teamWaitList,
    'teamMemberList' : teamMemberList,
  };
  static team fromSnap (DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return team(
      teamUID : snapshot['teamUID'],
      teamName : snapshot['teamName'],
      teamPhotoURL : snapshot['teamPhotoURL'],
      teamLeaderUID: snapshot['teamLeaderUID'],
      teamWaitList : snapshot['teamWaitList'],
      teamMemberList : snapshot['teamMemberList'],
    );
  }
}