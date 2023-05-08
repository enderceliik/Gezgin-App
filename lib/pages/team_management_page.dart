import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:yuruyus_app/models/team.dart' as tm;

class TeamManagementPage extends StatefulWidget {
  bool type = false;
  TeamManagementPage({super.key});

  @override
  State<TeamManagementPage> createState() => _TeamManagementPageState();
}

class _TeamManagementPageState extends State<TeamManagementPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInformation();
  }

  Future<List?> getData() async {
    // yedek aıl fonksiyon
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    List followingUsers = (snapshot.data()! as dynamic)[
        'following']; // Veritabanından çekmiş olduğumuz kullanıcı map'inden following listesini locl listeye aldık.
    return followingUsers;
  }
  void loadDataToDatabase() async {
    List members = ['rCsHZNuCeWeCxaeERFc88WTocAT2', 'LVTVFqWAzXQPur2AuVPcvXKS3JR2'];
    String teamUID = const Uuid().v1();
    tm.team team = tm.team(teamLeaderUID: FirebaseAuth.instance.currentUser!.uid ,teamName: 'Çelebiler', teamPhotoURL: '',teamMemberList: ['IuxaQQYg3xRg1TwfrrbRdaCe9ef2'], teamUID: teamUID,teamWaitList: members);
    FirebaseFirestore.instance.collection('teamRep').doc(teamUID).set(team.toJson(),);
    FirebaseFirestore.instance.collection('users').doc('rCsHZNuCeWeCxaeERFc88WTocAT2').update({'requests': FieldValue.arrayUnion([teamUID])});
    FirebaseFirestore.instance.collection('users').doc('LVTVFqWAzXQPur2AuVPcvXKS3JR2').update({'requests': FieldValue.arrayUnion([teamUID])});
  }

  void getInformation() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      String team = (snapshot.data()! as dynamic)['team'];
      if (team != '') {
        widget.type = false;
      } else {
        widget.type = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: widget.type
            ? const Text(
              'Ekibini oluştur!',
            )
            :const Text(
            'Gezgin',
            style: TextStyle(
              fontFamily: 'Shadows_Into_Light',
              fontWeight: FontWeight.bold,
              fontSize: 32.0,
            ),
          ),
            centerTitle: true),
        body: widget.type
            ? 
             FutureBuilder(
                future: newMethod(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: Colors.red), // Renk değiştirilecek
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            radius: 28.0,
                            backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic).docs[index]
                                  ['profilePhotoURL'],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text((snapshot.data! as dynamic).docs[index]
                              ['username']),
                        ]),
                      );
                    },
                  );
                },
              ): const Text('İçinde bulunulan grup gösterilir'),
        floatingActionButton: FloatingActionButton(
          onPressed: () => loadDataToDatabase(),
          child: const Icon(
            Icons.send_outlined,
          ),
        ),
      ),
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> newMethod() async =>
      FirebaseFirestore.instance
          .collection('users')
          .where('uid',
              whereIn:
                  await getData()) //.orderBy('distance', descending: true,)
          .get();
}
