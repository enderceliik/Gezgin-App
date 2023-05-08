import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  _MapSampleState createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  late BitmapDescriptor customIcon;
  Set<Marker> markers = {};
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

    ui.Image image = await getImageFromPath(
        imagePath);
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

      var icon = await createCustomMarkerBitmapWithNameAndImage(markerImageFile.path, s, name);
    
      return icon;
    } else {
      return BitmapDescriptor.defaultMarker;
    }
  }

  @override
  void initState() {
    super.initState();
    setAllMarkers();
  }

  setAllMarkers() async {
    markers.add(
      Marker(
        markerId: MarkerId("1"),
        position: LatLng(30.699285146824476, 76.69179040341325),
        icon: await getMarkerIcon(
            "https://firebasestorage.googleapis.com/v0/b/yuruyusapp-2b101.appspot.com/o/gunce%2FLVTVFqWAzXQPur2AuVPcvXKS3JR2%2F8f5b2e60-c969-11ed-8c0d-57a15b6e2b5a?alt=media&token=78f8ead5-6626-4049-92c6-73f2a730c3e9",
            "DAVID"),
      ),
    );
    setState(() {});
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: const LatLng(30.699285146824476, 76.69179040341325), zoom: 15),
          markers: markers),
    );
  }

}
