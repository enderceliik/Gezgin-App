// ignore_for_file: file_names

import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:yuruyus_app/resources/firestore_methods.dart';

import '../providers/user_provider.dart';

class AddGuncePage extends StatefulWidget {
  final Uint8List file;
  const AddGuncePage({super.key, required this.file});

  @override
  State<AddGuncePage> createState() => _AddGuncePageState();
}

class _AddGuncePageState extends State<AddGuncePage> {
  Position? currentUserPosition;
  bool gunceSituation = false;

  //void postImage(String uid, String username, String profImage) async {
  void postImage(Uint8List file) async {
    try {
      await FirestoreMethods()
      .uploadGunce(file,
      currentUserPosition!,
      FirebaseAuth.instance.currentUser!.uid);
      showMessageFunc();
    } catch (error) {
      // Hata seviyelendirilmesi + "İşlem gerçekleştirilemedi. Tekrar deneyiniz..."
    }
  }

  void _getUserLocation() async {
    bool permission = await _permissionsControlFunc();
    if (!permission) {
      return null;
    } else {
      Position? position;
      try {
        position = await GeolocatorPlatform.instance.getCurrentPosition(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.high));
        setState(() {
          // currentUserPosition = LatLng(position!.latitude, position.longitude);
          currentUserPosition = position;
          gunceSituation = true;
        });
      } catch (e) {
        print('Deneme hata');
      }
    }
  }

  Future<bool> _permissionsControlFunc() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.lightBlue[900],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  16.0,
                ),
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                    'Cihazında konum izni kalıcı olarak reddedildi. Uygulama ayarlarından izin verdikten sonra tekrar dene.',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Tamam'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }

  void showMessageFunc() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Günce yükleme işlemi başarılı!',
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Tamam',
          onPressed: () {
            // Navigator.of(context).pop();
            // return;
          },
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider
        userProvider = // Json yapısı değişirse ki değişebilir. Kullanılabilir. O yüzden dokunmuyorum.
        Provider.of<UserProvider>(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Gunce ekleme sayfasi',
      //   ),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: MemoryImage(
                widget.file,
              ),
              fit: BoxFit.cover,
              alignment: FractionalOffset.topCenter),
        ),
      ),

      floatingActionButton: gunceSituation == false
          ? const CircularProgressIndicator()
          : FloatingActionButton(
              onPressed: () => postImage(widget.file
                  //userProvider.getUser.uid,
                  //userProvider.getUser.username,
                  //userProvider.getUser.profilePhotoURL,
                  ),
              backgroundColor: const Color.fromARGB(255, 76, 175, 163),
              child: const Icon(Icons.upload),
            ),
    );
  }
}
