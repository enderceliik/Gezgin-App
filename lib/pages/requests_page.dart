import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestsPage extends StatefulWidget {
  final List requestList;
  const RequestsPage({super.key, required this.requestList});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List?> getData() async {
    // yedek aıl fonksiyon
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    List requests = (snapshot.data()! as dynamic)[
        'requests']; // Veritabanından çekmiş olduğumuz kullanıcı map'inden following listesini locl listeye aldık.
    return requests;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Davetlerin: ',
          ),
        ),
        body: widget.requestList.isEmpty == false
            ? FutureBuilder(
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
                                  ['teamPhotoURL'],
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text((snapshot.data! as dynamic).docs[index]
                              ['teamName']),
                          const SizedBox(
                            width: 30.0,
                          ),
                          InkWell(
                            //Onayla
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                'requests': FieldValue.arrayRemove(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['teamUID'])
                              });
                              await FirebaseFirestore.instance
                                  .collection('teampRep')
                                  .doc((snapshot.data! as dynamic).docs[index]
                                      ['teamUID'])
                                  .update({
                                'teamWaitList': FieldValue.arrayRemove([
                                  (snapshot.data! as dynamic).docs[index]
                                      ['teamUID']
                                ])
                              });
                              await FirebaseFirestore.instance
                                  .collection('teampRep')
                                  .doc((snapshot.data! as dynamic).docs[index]
                                      ['teamUID'])
                                  .update({
                                'teamMemberList': FieldValue.arrayUnion(
                                    [FirebaseAuth.instance.currentUser!.uid])
                              });
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                'team': (snapshot.data! as dynamic)
                                    .docs[index]['teamUID']
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: 100.0,
                              height: 35.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blueAccent,
                                ),
                                borderRadius: BorderRadius.circular(
                                  5.0,
                                ),
                              ),
                              child: const Text(
                                'onayla',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          InkWell(
                            //reddet
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .update({
                                'requests': FieldValue.arrayRemove(
                                    (snapshot.data! as dynamic).docs[index]
                                        ['teamUID'])
                              });
                              await FirebaseFirestore.instance
                                  .collection('teampRep')
                                  .doc((snapshot.data! as dynamic).docs[index]
                                      ['teamUID'])
                                  .update({
                                'teamWaitList':
                                    FieldValue.arrayRemove([index])
                              });
                            },
                            child: Container(
                              width: 100.0,
                              height: 35.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blueAccent,
                                ),
                                borderRadius: BorderRadius.circular(
                                  8.0,
                                ),
                              ),
                              child: const Text(
                                'reddet',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ),
                        ]),
                      );
                    },
                  );
                },
              )
            : Container(
                alignment: Alignment.center,
                child: const Text(
                  'Herhangi bir davetiyeniz bulunmamaktadır.',
                ),
              ),
      ),
    );
  }

  Future<QuerySnapshot<Map<String, dynamic>>> newMethod() async =>
      FirebaseFirestore.instance
          .collection('teamRep')
          .where('teamUID',
              whereIn:
                  await getData()) //.orderBy('distance', descending: true,)
          .get();
}
