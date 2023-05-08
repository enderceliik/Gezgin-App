// ignore_for_file: file_names

import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:label_marker/label_marker.dart';
import 'package:network_image_to_byte/network_image_to_byte.dart';
import 'package:yuruyus_app/pages/profile_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'gunce_page.dart';
import 'gunce_show_page.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as IMG;
import 'package:yuruyus_app/pages/paint_page.dart';

// --
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserGezgin extends StatefulWidget {
  const UserGezgin({super.key});

  @override
  State<UserGezgin> createState() => _UserGezginState();
}

class _UserGezginState extends State<UserGezgin> {
  final TextEditingController searchController = TextEditingController();
  LatLng? currentUserPosition;
  bool isShowUsers = false;
  final LatLng _startPos = const LatLng(40.458550, 39.478533);
  late GoogleMapController googleMapController;
  // Map<MarkerId, LabelMarker> markers = <MarkerId, LabelMarker>{};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  final LatLng _startPositionEmulator = const LatLng(40.999040, 39.758796);
  final LatLng _currentPositionEmulator = const LatLng(41.005457, 39.730164);

  void _getUserLocation() async {
    // _markers.addLabelMarker(LabelMarker(
    //   label: '@guler.davut29',
    //   markerId: MarkerId('@guler.davut29'),
    //   position: LatLng(41.001135, 39.639922),
    //   backgroundColor: Colors.green,
    // ));
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
          currentUserPosition = LatLng(position!.latitude, position.longitude);
        });
      } catch (e) {
        position = await Geolocator.getLastKnownPosition();
        if (position != null) {
          setState(
            () {
              currentUserPosition =
                  LatLng(position!.latitude, position.longitude);
            },
          );
        }
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

  Future<List?> getData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    List followingUsers = (snapshot.data()! as dynamic)['following'];
    followingUsers.add(FirebaseAuth.instance.currentUser!.uid);
    return followingUsers;
  }

  // void initMarker(specify, specifyID) async {
  void initMarker(gunce) async {
    var snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(gunce['uid'])
        .get();
    String username = snap.data()!['username'];
    Uint8List customMarker = await networkImageToByte(gunce['gunceURL']);
    customMarker = resizeImage(customMarker)!;
    final Marker marker = Marker(
      markerId: MarkerId(gunce['uid']),
      position: LatLng(
          gunce['guncePosition']
          .latitude, 
          gunce['guncePosition']
          .longitude),
      icon: BitmapDescriptor.fromBytes(customMarker),
      infoWindow: InfoWindow(
        title: username,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GunceShowPage(
                gunceID: gunce['gunceID'],
              ),
            ),
          );
        },
      ),
    );
    setState(() {
      markers[MarkerId(gunce['uid'])] = marker;
    });
  }

  getMarkerData() async {
    var gunceSnapshots = await FirebaseFirestore.instance
        .collection('gunceRep')
        .where('uid', whereIn: await getData())
        .get();
    List gunceListFromQuerySnapshot =
        gunceSnapshots.docs.map((doc) => doc.data()).toList();
    for (int i = 0; i < gunceListFromQuerySnapshot.length; i++) {
      initMarker(gunceListFromQuerySnapshot[i]);
    }
  }

  Uint8List? resizeImage(Uint8List data) {
    Uint8List? resizedData = data;
    IMG.Image? img = IMG.decodeImage(data);
    IMG.Image resized = IMG.copyResize(img!,
        width: (MediaQuery.of(context).size.width * 0.1).toInt(),
        height: (MediaQuery.of(context).size.height * 0.1).toInt());
    resizedData = IMG.encodeJpg(resized) as Uint8List?;
    return resizedData;
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    getMarkerData();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Set<Marker> getMarker() {
    //   return <Marker>[
    //     Marker(
    //       markerId: MarkerId('valu1'),
    //       position: LatLng(41.001135, 39.639922),
    //       infoWindow: InfoWindow(
    //         title: 'Marker 1',
    //       ),
    //     ),
    //   ].toSet();
    // }

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
            controller: searchController,
            style: const TextStyle(
              color: Colors.white70,
            ),
            decoration: InputDecoration(
              prefixIcon: isShowUsers
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          isShowUsers = false;
                        });
                        searchController.clear();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white54,
                      ),
                    )
                  : const Icon(Icons.search, color: Colors.white54),
              labelText: 'Ara',
              labelStyle: const TextStyle(
                color: Colors.white54,
              ),
            ),
            onFieldSubmitted: (String _) {
              setState(
                () {
                  isShowUsers = true;
                },
              );
            }),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController
                          .text) // where koşulu ile controller'ımızın o an tuttuğu string'e göre firestore'daki 'username'
                  .get(), // alanlarına yapacağımız aramayı filtrelemiş olduk.
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
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
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]
                                ['profilePhotoURL'],
                          ),
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : currentUserPosition == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    backgroundColor: Colors.blueAccent,
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    // target: currentUserPosition!,
                    target: _startPositionEmulator,
                    zoom: 15.0,
                  ),
                  mapType: MapType.normal,
                  // markers: Set<LabelMarker>.of(markers.values),
                  markers: Set<Marker>.of(markers.values),
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                  },
                ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 38.0,bottom: 2.0),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Icon(Icons.share_location_outlined,color: Colors.blueAccent,),
          onPressed: () async {
            Position position = await Geolocator.getCurrentPosition();
            googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                    // target: LatLng(position.latitude, position.longitude),
                    target: _currentPositionEmulator,
                    zoom: 17),
              ),
            );
            //markers.clear();
            Marker marker = Marker(
                markerId: MarkerId("current Position"),
                // position: LatLng(position.latitude, position.longitude),
                position: _currentPositionEmulator,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueCyan));
            markers[MarkerId(FirebaseAuth.instance.currentUser!.uid)] = marker;
            setState(() {});
          },
        ),
      ),
    );
  }

  Future<BitmapDescriptor> createCustomMarkerBitmapWithNameAndImage(
      String imagePath, Size size, String name) async {
    TextSpan span = new TextSpan(
        style: new TextStyle(
          height: 1.2,
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.normal,
        ),
        text: name);

    TextPainter tp = new TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = new Canvas(recorder);

    final double shadowWidth = 15.0;
    final double borderWidth = 2.0;
    final double imageOffset = shadowWidth + borderWidth;

    final Radius radius = Radius.circular(size.width / 2);

    final Paint shadowCirclePaint = Paint()
      ..color = Theme.of(context).primaryColor;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              size.width / 8, size.width / 2, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowCirclePaint);

    // TEXT BOX BACKGROUND
    Paint textBgBoxPaint = Paint()..color = Theme.of(context).primaryColor;

    Rect rect = Rect.fromLTWH(
      0,
      0,
      tp.width + 35,
      50,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(10.0)),
      textBgBoxPaint,
    );

    //ADD TEXT WITH ALIGN TO CANVAS
    tp.paint(canvas, new Offset(20.0, 5.0));

    /* Do your painting of the custom icon here, including drawing text, shapes, etc. */

    Rect oval = Rect.fromLTWH(35, 78, size.width - (imageOffset * 2),
        size.height - (imageOffset * 2));

    // ADD  PATH TO OVAL IMAGE
    canvas.clipPath(Path()..addOval(oval));

    ui.Image image = await getImageFromPath(imagePath);
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    ui.Picture p = recorder.endRecording();
    ByteData? pngBytes = await (await p.toImage(300, 300))
        .toByteData(format: ui.ImageByteFormat.png);

    Uint8List data = Uint8List.view(pngBytes!.buffer);

    return BitmapDescriptor.fromBytes(data);
  }

  Future<ui.Image> getImageFromPath(String imagePath) async {
    File imageFile = File(imagePath);

    Uint8List imageBytes = imageFile.readAsBytesSync();

    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  Future<BitmapDescriptor> getMarkerIcon(String image, String name) async {
    if (image != null) {
      final File markerImageFile =
          await DefaultCacheManager().getSingleFile(image);
      Size s = const Size(120, 120);

      var icon = await createCustomMarkerBitmapWithNameAndImage(
          markerImageFile.path, s, name);

      return icon;
    } else {
      return BitmapDescriptor.defaultMarker;
    }
  }
}
