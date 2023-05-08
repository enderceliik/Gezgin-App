import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GunceShowPage extends StatefulWidget {
  final String gunceID;
  const GunceShowPage({super.key, required this.gunceID});
  @override
  State<GunceShowPage> createState() => _GunceShowPageState();
}

class _GunceShowPageState extends State<GunceShowPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLiked = false;
  String gunceURL = '';
  late List likes;
  @override
  void initState() {
    super.initState();
    getGunce();
  }

  getGunce() async {
    try {
      var snapshot = await _firestore
          .collection('gunceRep')
          .doc(widget.gunceID)
          .get();
      var snap = await _firestore.collection('gunceRep').doc(widget.gunceID).get();
      await _firestore.collection('gunceRep').doc(widget.gunceID).update({'viewList': FieldValue.arrayUnion([_auth.currentUser!.uid])});
      List like = snap.data()!['likes'];
      setState(() {
        likes = like;
        if(likes.contains(_auth.currentUser!.uid))
        {
          isLiked = true;
        }
        else
        {
          isLiked = false;
        }
        gunceURL = snapshot.data()!['gunceURL'];
      });
    } catch (exception) {
      print(exception.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 64, 56, 53),
        body: gunceURL == ''
        ?const Center(
            child: CircularProgressIndicator(),
          )
        :Stack(
          children:<Widget> [ Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: FractionalOffset.topCenter,
                image: NetworkImage(
                  gunceURL,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20.0,
            bottom: 20.0,
            child: GestureDetector(
              onTap: () {
                if(isLiked == true) // Buraya beğenenler listesi yapılabilir veya bildirim sistemmi oluşturur isem bildirimler de gözükmesini sağlayan fonksiyon yazılabilir
                {
                  _firestore.collection('gunceRep').doc(widget.gunceID).update({'likes': FieldValue.arrayRemove([(_auth.currentUser!.uid)])});
                  setState(() {
                    isLiked = false;
                  });
                  
                }
                else
                {
                  _firestore.collection('gunceRep').doc(widget.gunceID).update({'likes': FieldValue.arrayUnion([(_auth.currentUser!.uid)])});
                  setState(() {
                    isLiked = true;
                  });
                }
              },
              child: isLiked 
              ?const Icon(Icons.favorite,color: Colors.blueAccent,size: 48.0)    
              :const Icon(Icons.favorite_border,color: Colors.blueAccent,size: 48.0)
            ),
          )],
        ),
      ),
    );
    
  }
}
