// ignore_for_file: file_names

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../resources/storage_methods.dart';
import '../utils/utils.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  var userData = {};
  String username = '';
  String name = '';
  String profilePhotoURL = '';

  @override
  void initState() {
    super.initState();
    getData();
  }
  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      userData = userSnap.data()!;
      setState(() {
        username = userSnap.data()!['username'];
        name = userSnap.data()!['name'];
        profilePhotoURL = userSnap.data()!['profilePhotoURL'];
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
  }
  
  void updateData () async{
    try {
    _usernameController.text.isEmpty ? 
    await FirebaseFirestore.instance
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .update({'username' : username, // Profil tablosunu oluşturduğumuz kısım.
  }): await FirebaseFirestore.instance
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .update({'username' : _usernameController.text, // Profil tablosunu oluşturduğumuz kısım.
  }); 
  await FirebaseFirestore.instance
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .update({'name' : _nameController.text, // Profil tablosunu oluşturduğumuz kısım.
  });
} on Exception catch (exception) {
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
  }
  
  void selectImage() async {
    // Cihaz hafızasından profil fotoğrafını seçme arayüzünü açıp fotoğrafı seçtiriyoruz.
    Uint8List profilImage = await pickImage(ImageSource.gallery); 
    firebaseSync(profilImage); //Cloud Firestore'a yüklemek için fonksiyonu çağırdık.
  }

  //Uint8List tipinde galeriden seçilen fotoğrafı parametre alıp cloud firestore'a yükleyen fonksiyon.
  void firebaseSync(Uint8List imageFile) async 
  {
    String photoURL = await StorageMethods().uploadImageToStorage('profilePics/', imageFile, false);
    
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      'profilePhotoURL' : photoURL, // Profil tablosunu oluşturduğumuz kısım.
    }); 
    getData();  // Yeni seçilip yüklenen fotoğrafın o sayfadaki eski olanın yerini alması için
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: const Text(
          'Profil düzenle',
        ),
      ),
      body: Center(
        child: Container(
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
                Color.fromARGB(255, 39, 55, 144),
                Colors.teal,
                Color.fromARGB(1, 153, 226, 255),
                
                
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                // Profile Picture
                padding: const EdgeInsets.only(
                  top: 25.0,
                ),
                child: GestureDetector(
                  onTap: () {
                    selectImage(); 
                  },
                  child: Stack(
                children: [
                  profilePhotoURL != ''
                      ? CircleAvatar(
                          radius: 96,
                          backgroundImage: NetworkImage(profilePhotoURL), //null check
                        )
                      : const CircleAvatar(
                          radius: 96,
                          backgroundColor: Colors.grey,
                          //backgroundImage: NetworkImage(
                          // 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pngitem.com%2Fmiddle%2FixJxJh_default-profile-picture-circle-hd-png-download%2F&psig=AOvVaw2ToCTyfpqwR4DNy23VhEd4&ust=1667031839871000&source=images&cd=vfe&ved=0CAwQjRxqFwoTCLC0v9e_gvsCFQAAAAAdAAAAABAE',
                          // ),
                        )
                ],
              ),
                ),
              ),
              const SizedBox(height: 12.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    disabledBorder: InputBorder.none,
                    border: InputBorder.none,
                  hintText: 'Kullanıcı adı: $username',
                  hintStyle: const TextStyle(color: Colors.lightBlue),
                  
                        filled: true,
                        fillColor: Colors.white,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    disabledBorder: InputBorder.none,
                    border: InputBorder.none,
                  hintText: 'Ad: $name',
                  hintStyle: const TextStyle(color: Colors.lightBlue),
                  
                        filled: true,
                        fillColor: Colors.white,
                      ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: MaterialButton(
                  onPressed: updateData,
                  color: Colors.lightBlue,
                  child: const Text(
                    'Düzenle',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
