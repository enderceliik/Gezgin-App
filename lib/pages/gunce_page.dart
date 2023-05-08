// ignore_for_file: file_names

import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yuruyus_app/pages/gunce_show_page.dart';
import 'package:yuruyus_app/pages/profile_page.dart';
import 'package:yuruyus_app/pages/requests_page.dart';
import 'package:yuruyus_app/pages/team_management_page.dart';
import 'package:yuruyus_app/utils/utils.dart';
import 'package:yuruyus_app/pages/add_gunce.dart';

class UserGunce extends StatefulWidget {
  const UserGunce({super.key});

  @override
  State<UserGunce> createState() => _UserGunceState();
}

class _UserGunceState extends State<UserGunce> {
  late FixedExtentScrollController listWheelScrollViewController;
  late bool isShow;
  late List nofiticationList;
  bool anyNofitication = false;
  Map <String, List> gunceS = <String, List>{};

  @override
  void initState() {
    super.initState();
    listWheelScrollViewController = FixedExtentScrollController();
    getNofitication();
    checkGunceDate('2ac2cfc0-c96a-11ed-9030-c9bc94d85e4d');
  }

  void getNofitication() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      nofiticationList = (snapshot.data()! as dynamic)['requests'];
      if (nofiticationList.isEmpty) {
        anyNofitication = true;
      }
      else
      {
        anyNofitication = false;
      }
    });
  }

  Future checkGunceDate(String gunceID) async {
    try {
      var gunceSnapshots = await FirebaseFirestore.instance
        .collection('gunceRep')
        .where('uid', whereIn: await getData())
        .get();
      List gunceListFromQuerySnapshot =
        gunceSnapshots.docs.map((doc) => doc.data()).toList();
    for (int i = 0; i < gunceListFromQuerySnapshot.length; i++) {
      setState(() {
        gunceS[gunceListFromQuerySnapshot[i]['uid']] = gunceListFromQuerySnapshot[i]['viewList'];
        var variable = gunceS[gunceListFromQuerySnapshot[i]['uid']];
      });
    }
    } catch (exception) {
        print('HATA');
    }
  }

  @override
  void dispose() {
    listWheelScrollViewController.dispose();
    super.dispose();
  }

  Future<List?> getData() async {
    // yedek aıl fonksiyon
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    List followingUsers = (snapshot.data()! as dynamic)[
        'following']; // Veritabanından çekmiş olduğumuz kullanıcı map'inden following listesini locl listeye aldık.
    followingUsers.add(FirebaseAuth.instance.currentUser!.uid);
    return followingUsers;
  }
  // List gunc(String uid){
  //   List liste = Set<uid>.of(gunceS.values);
  //   return liste;
  // }
  void callAddGuncePage(Uint8List file) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddGuncePage(file: file),
      ),
    );
  }


  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              'Fotoğraf Seç',
            ),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(
                  8.0,
                ),
                child: const Text(
                  'Kamerayı Aç',
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  if (file != null) { // file boş olabilir kamera'dan geri gelince özel bir metod var mı bakacağım.
                    callAddGuncePage(file);
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(
                  8.0,
                ),
                child: const Text(
                  'Galeriden Seç',
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  if (file != null) {
                    callAddGuncePage(file);
                  }
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: const Text(
            'Gezgin',
            style: TextStyle(
              fontFamily: 'Shadows_Into_Light',
              fontWeight: FontWeight.bold,
              fontSize: 36.0,
            ),
          ),
          //centerTitle: true,
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(
                  right: 20.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RequestsPage(requestList: nofiticationList),
                      ),
                    );
                  },
                  child: anyNofitication
                      ? const Icon(
                          Icons.notifications,
                        )
                      : const Icon(Icons.notifications_active,
                          color: Color.fromARGB(255, 255, 128, 1)),
                ),),
                Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
              ),
              child: GestureDetector(
                onTap: () {
                     Navigator.of(context).push(
                       MaterialPageRoute(builder: (context) => TeamManagementPage()),
                    );
                },
                child: const Icon(
                  Icons.run_circle_outlined,
                  size: 26.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
              ),
              child: GestureDetector(
                onTap: () {
                  _selectImage(context);
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => OzellikDeneme()),
                  //  );
                },
                child: const Icon(
                  Icons.add_box,
                  size: 26.0,
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: newMethod(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                    color: Colors.white), // Renk değiştirilecek
              );
            }

            // return ListView.builder(
            //   itemCount: (snapshot.data! as dynamic).docs.length,
            //   itemBuilder: (context, index) {
            //     return InkWell(
            //       // Günce ekranında herhangi bir profile dokunulduğunda o profile yönlendiriyoruz
            //       onTap: () {
            //         if ((snapshot.data! as dynamic).docs[index][
            //                 'uid'] == // Kendi profiline dokunması durumunda Günce ekleme arayüzü, yönlendirme menüsü
            //             FirebaseAuth.instance.currentUser!.uid) {
            //         } else {
            //           Navigator.of(context).push(
            //             MaterialPageRoute(
            //               builder: (context) => ProfilePage(
            //                 uid: (snapshot.data! as dynamic).docs[index]['uid'],
            //               ),
            //             ),
            //           );
            //         }
            //       },

            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Container(
            //           child: Column(children: [
            //             CircleAvatar(
            //               backgroundColor: Colors.blueGrey,
            //               radius: 56.0,
            //               backgroundImage: NetworkImage(
            //                 (snapshot.data! as dynamic).docs[index]
            //                     ['profilePhotoURL'],
            //               ),
            //             ),
            //             const SizedBox(
            //               height: 20,
            //             ),
            //             Text((snapshot.data! as dynamic).docs[index]
            //                 ['username']),
            //           ]),
            //         ),
            //       ),
            //     );
            //   },
            // );

            return ClickableListWheelScrollView(
              itemHeight: 100,
              scrollController: listWheelScrollViewController,
              itemCount: (snapshot.data! as dynamic).docs.length,
              onItemTapCallback: (index) {
                if ((snapshot.data! as dynamic).docs[index]['gunce'] != '') {
                  String gunceUID =
                      (snapshot.data! as dynamic).docs[index]['gunce'];
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GunceShowPage(
                        gunceID: gunceUID,
                      ),
                    ),
                  );
                }
                // if(gunceS[(snapshot.data! as dynamic).docs[index]['uid']] )
                // else if ((snapshot.data! as dynamic).docs[index][
                //         'uid'] == // Kendi profiline dokunması durumunda Günce ekleme arayüzü, yönlendirme menüsü
                //     FirebaseAuth.instance.currentUser!.uid) {
                //       Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (context) => ProfilePage(
                //         uid: (snapshot.data! as dynamic).docs[index]['uid'],
                //       ),
                //     ),
                //   );
                //   //Burası ayarlanacak aslında aynı route üzerinden gidiyor farklı profile de

                // }
                else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        uid: (snapshot.data! as dynamic).docs[index]['uid'],
                      ),
                    ),
                  );
                }
              },
              child: ListWheelScrollView.useDelegate(
                controller: listWheelScrollViewController,
                squeeze: 0.95,
                //magnification: 1.2,
                //useMagnifier: true,

                perspective: 0.001, // Silindir iç açı
                physics: const FixedExtentScrollPhysics(),
                itemExtent: 100,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: (snapshot.data! as dynamic).docs.length,
                  builder: (BuildContext context, int index) {
                    return GestureDetector(
                      // Günce ekranında herhangi bir profile dokunulduğunda o profile yönlendiriyoruz
                      // onTap: () {
                      //   if ((snapshot.data! as dynamic).docs[index]['gunce'] !=
                      //       '') {
                      //     String gunceUID =
                      //         (snapshot.data! as dynamic).docs[index]['gunce'];
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) => GunceShowPage(
                      //           gunceID: gunceUID,
                      //         ),
                      //       ),
                      //     );
                      //   }
                      //   if ((snapshot.data! as dynamic).docs[index][
                      //           'uid'] == // Kendi profiline dokunması durumunda Günce ekleme arayüzü, yönlendirme menüsü
                      //       FirebaseAuth.instance.currentUser!.uid) {
                      //   } else {
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) => ProfilePage(
                      //           uid: (snapshot.data! as dynamic).docs[index]
                      //               ['uid'],
                      //         ),
                      //       ),
                      //     );
                      //   }
                      // },
                      child: Container(
                        width: 360,
                        // decoration: (snapshot.data! as dynamic).docs[index]
                        //             ['gunce'] != ''

                        // decoration: checkGunceDate((snapshot.data! as dynamic) // Günce var ise farklı yok ise farklı BoxDecoration vermek için düzenlenecek...
                        //             .docs[index]['gunce']) ==
                        //         true
                        //     ? BoxDecoration(
                        //         border: Border.all(
                        //             color: const Color.fromARGB(127, 199, 36, 7),
                        //             width: 2.0),
                        //         color: const Color.fromARGB(127, 199, 36, 7),
                        //         borderRadius: BorderRadius.circular(8.0),
                        //       )
                        //     : BoxDecoration(
                        //         color: const Color(0x800097A7),
                        //         borderRadius: BorderRadius.circular(8.0),
                        //       ),
                        decoration: BoxDecoration(
                                color: const Color(0x800097A7),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.blueGrey,
                                    radius: 29.0,
                                    backgroundImage: NetworkImage(
                                      (snapshot.data! as dynamic).docs[index]
                                          ['profilePhotoURL'],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                      '@${(snapshot.data! as dynamic).docs[index]['username']}',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(
                                      0.8,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      2.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('${(snapshot.data! as dynamic).docs[index]['distance'].toString()} KM',
                                      style: const TextStyle(
                                        color: Colors.lightBlueAccent,
                                        fontSize: 12.0,
                                        //fontFamily: 'Shadows_Into_Light',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ));
  }

  Future<QuerySnapshot<Map<String, dynamic>>> newMethod() async =>
      FirebaseFirestore.instance
          .collection('users')
          .where('uid',
              whereIn:
                  await getData()) //.orderBy('distance', descending: true,)
          .get();
}
