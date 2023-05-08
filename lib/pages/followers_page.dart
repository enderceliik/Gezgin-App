import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yuruyus_app/pages/profile_page.dart';

class FollowersAndFollowingPage extends StatefulWidget {
  final bool whichOne;
  final String userUID;
  const FollowersAndFollowingPage({super.key, required this.whichOne, required this.userUID});

  @override
  State<FollowersAndFollowingPage> createState() => _FollowersAndFollowingPageState();
}

class _FollowersAndFollowingPageState extends State<FollowersAndFollowingPage> {
  var userData = {};
  //bool ?whichOne;
  String appBarText = '';
  String username = '';
  String name = '';
  String profilePhotoURL = '';
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    getData();
    getInfo();
  }
  
  void getInfo() async{
    setState(() {
      if(widget.whichOne == true)
      {
        appBarText = 'Takip Edilenler';
      }
      else{
        appBarText = 'Takipçiler';
      }
    });
  }

  Future<List?> getData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userUID)
        .get();

    if(widget.whichOne == true)
    {
      List userList = (snapshot.data()! as dynamic)['following'];
      return userList;
    }
    else{
      List userList = (snapshot.data()! as dynamic)['followers'];
      return userList;

    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(appBarText), centerTitle: true,),
        body: FutureBuilder(
              future: newMethod(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // if((snapshot.data! as dynamic)("uid") == FirebaseAuth.instance.currentUser!.uid)
                // {
                //   return Text('deneme');
                // }

                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              uid: (snapshot.data! as dynamic).docs[index]
                                  ['uid'],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            radius: 48.0,
                            backgroundImage: NetworkImage((snapshot.data! as dynamic).docs[index]
                                ['profilePhotoURL'],),
                          ),
                          const SizedBox(width: 20,),
                          Text((snapshot.data! as dynamic).docs[index]['username']),
                        ]),
                      ),
                    );
                  },
                );
              },
            )
      ),
    );
  }
  Future<QuerySnapshot<Map<String, dynamic>>> newMethod() async => FirebaseFirestore.instance.collection('users')
          .where('uid',whereIn: await getData()).get();
}
