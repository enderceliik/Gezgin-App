import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yuruyus_app/models/user.dart' as model;

class Resource {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Class içinde kullanabilmek için Firebase sınıfından bir nesne oluşturduk
  final FirebaseFirestore _firestore = FirebaseFirestore
      .instance; // Class içinde kullanabilmek için Firebasefirestore sınıfından bir nesne oluşturduk

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }
  Future<String> signUpUserFunction({ // KULLANIMDA DEGIL KULLANICI KAYDI VE VERILERIN FIRESTORE'A YAZILMASI UTILS ICINDEKI CONVERT VASITASI ILE DIREKT SignPage'deki fonksiyon ile yapılıyor.
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController usernameController,
    //required Uin8List file; // fotoğraf için daha sonra ayarlar kısmında ekleyeceğim.
  }) async {
    try {
      if (isPasswordConfirmed(passwordController)) {
        UserCredential cred =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        await _firestore.collection('users').doc(cred.user!.uid).set(
          {
            'email': emailController.text.trim(),
            'uid': cred.user!.uid,
            'username': usernameController.text.trim(),
            'followers': [],
            'following': [],
          },
        );
      } else {}
    } catch (error) {
      print("Hata");
    }
    return 'basarili';
  }

  bool isPasswordConfirmed(TextEditingController passwordController) {
    if (passwordController.text.trim() == passwordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> followUser( //Takip edilme veya etme durumunu kullanıcı ID ile her iki kullanıcıdaki following ve followers listelerine update ettiğimiz fonksiyon
    String uid,
    String followId,
  ) async {
    try{
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if(following.contains(followId))
      {
        await _firestore.collection('users').doc(followId).update({'followers': FieldValue.arrayRemove([uid])});
        await _firestore.collection('users').doc(uid).update({'following': FieldValue.arrayRemove([followId])});
      }
      else
      {
        await _firestore.collection('users').doc(followId).update({'followers': FieldValue.arrayUnion([uid])});
        await _firestore.collection('users').doc(uid).update({'following': FieldValue.arrayUnion([followId])});
      }
    }
    catch (exception)
    {
      print(exception.toString());
    }
  }
}
