import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yuruyus_app/pages/followers_page.dart';
import 'package:yuruyus_app/pages/profile_edit_page.dart';
import 'package:yuruyus_app/resources/resource.dart';
import 'package:yuruyus_app/widgets/follow_button.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userData = {};
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  String username = '';
  int distance = -1;
  String name = '';
  String profilePhotoURL = '';
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      setState(() {
        username = userSnap.data()!['username'];
        name = userSnap.data()!['name'];
        profilePhotoURL = userSnap.data()!['profilePhotoURL'];
        followers = userSnap.data()!['followers'].length;
        following = userSnap.data()!['following'].length;
        distance = userSnap.data()!['distance'];
        isFollowing = userSnap
            .data()!['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid); // True or False
      });
    } catch (exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            exception.toString(),
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Tamam',
            onPressed: () {},
          ),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            // appBar: FirebaseAuth.instance.currentUser!.uid == widget.uid
            // ?AppBar(title: const Text('Kendisi'),)
            // :AppBar(title: const Text('Different'),),
            body:Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.1,
                    0.5,
                    0.9,
                  ],
                  colors: [
                    Color.fromARGB(255, 17, 30, 101),
                    Colors.teal,
                    Color.fromARGB(1, 153, 226, 255),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Padding(   // Önceki tasarımda; Üst taraftaki Drawer ve Profil Düzenleme butonlarını içeren Row
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       GestureDetector(
                  //         // Edit Icon Button
                  //         onTap: () {
                  //           Scaffold.of(context).openDrawer();
                  //         },
                  //         child: const Padding(
                  //           padding: EdgeInsets.all(10),
                  //           child: Icon(
                  //             Icons.line_weight_outlined,
                  //             size: 30,
                  //           ),
                  //         ),
                  //       ),
                  //       GestureDetector(
                  //         // Edit Icon Button
                  //         onTap: () {
                  //           Navigator.push(context, MaterialPageRoute(
                  //             builder: (context) {
                  //               return const ProfileEditPage();
                  //             },
                  //           ));
                  //         },
                  //         child: const Padding(
                  //           padding: EdgeInsets.all(10),
                  //           child: Icon(
                  //             Icons.edit_outlined,
                  //             size: 30,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    // Profil fotoğrafını CircleAvatar Widget'i ile gösterdiğimiz kısım
                    padding: const EdgeInsets.only(
                      top: 50.0,
                    ),
                    child: Stack(
                      children: [
                        profilePhotoURL !=
                                '' // Veritabanındaki fotoğrafın URL adresini döndürdüğümüz profilePhotoURL değişkeni boş değil ise;
                            ? CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 112,
                                backgroundImage:
                                    NetworkImage(profilePhotoURL), //null check
                              )
                            : const CircleAvatar(
                                //boş ise;
                                radius: 112,
                                backgroundColor: Colors
                                    .grey, // Default Profile Photo hata veriyordu çözmeye çalıştım sonraya bıraktım
                                //backgroundImage: NetworkImage('data:https://www.google.com/url?sa=i&url=https%3A%2F%2Fsoccerpointeclaire.com%2Ffor-coaches%2Fdefault-profile-pic-e1513291410505%2F&psig=AOvVaw1PPXnvVCDqrXeLWc0_2vzD&ust=1667855353769000&source=images&cd=vfe&ved=0CA0QjRxqFwoTCNDzsMG7mvsCFQAAAAAdAAAAABAJ', scale: 3.0),
                              ),
                        Positioned(
                          bottom: 0,
                          left: 125,
                          child: Stack(
                            children: [
                              distance != -1
                                  ? Container(
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
                                        child: Text(distance.toString(),
                                          style: const TextStyle(
                                            color: Colors.lightBlueAccent,
                                            fontSize: 20.0,
                                            fontFamily: 'Shadows_Into_Light',
                                          ),
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      '0 KM',
                                      style: TextStyle(
                                        fontSize: 35.0,
                                        fontFamily: 'Shadows_Into_Light',
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        '@$username',
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 12.0,
                  ),

                  Stack(
                    children: [
                      name != null
                          ? Text(
                              name,
                              style: const TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            )
                          : const SizedBox(
                              height: 7.5,
                            ),
                    ],
                  ),

                  const SizedBox(
                    height: 20.0,
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return FollowersAndFollowingPage(
                                    whichOne: false, userUID: widget.uid);
                              },
                            ));
                          },
                        child: Column(children: [
                          const Text(
                            'Takipçiler',
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            followers.toString(),
                            style: const TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return FollowersAndFollowingPage(
                                    whichOne: true, userUID:  widget.uid);
                              },
                            ));
                          },
                        child: Column(children: [
                          const Text(
                            'Takip Edilenler',
                            style: TextStyle(
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            following.toString(),
                            style: const TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Kullanıcının uid'si ile görüntülemek istediği profilin uid'sini karşılaştırıyoruz.
                      FirebaseAuth.instance.currentUser!.uid == widget.uid 
                          ? Padding( // Aynı ise kendi profilini görüntülüyor demektir ki o durumda butonun görünümü ve işlevi:
                              padding: const EdgeInsets.all(12.0),
                              child: FollowButton(
                                backgroundColor: Colors.blue,
                                borderColor: Colors.blue,
                                textColorForTextButton: Colors.white,
                                textForTextButton: 'Profili Düzenle',
                                function: () async {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return const ProfileEditPage();
                                    },
                                  ));
                                },
                              ),
                            )
                          : isFollowing  // Farklı bir profili görüntülüyor ve bizim daha önce tanımladığımız 
                                         // isFollowing boolean değerimiz true ise bu farklı bir kişi ve onu takip ediyor: 
                              ? Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: FollowButton(
                                    backgroundColor:
                                        Colors.teal.withOpacity(0.6),
                                    borderColor: Colors.blue,
                                    textColorForTextButton: Colors.white,
                                    textForTextButton: 'Takibi Bırak',
                                    function: () async {
                                      await Resource().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid']);
                                      setState(() {
                                        isFollowing = false;
                                        followers--;
                                      });
                                    },
                                  ),
                                )
                              : Padding(  // Farklı profil ve takip etmeme senaryosu:
                                  padding: const EdgeInsets.all(12.0),
                                  child: FollowButton(
                                    backgroundColor: Colors.teal,
                                    borderColor: Colors.teal,
                                    textColorForTextButton: Colors.white,
                                    textForTextButton: 'Takip Et',
                                    function: () async {
                                      await Resource().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid']);
                                      setState(() {
                                        isFollowing = true;
                                        followers++;
                                      });
                                    },
                                  ),
                                )
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
