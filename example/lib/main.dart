import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String?> downloadAndSaveImage() async {
    // Download the image
    final response = await http.get(Uri.parse(
        "https://d1hjkbq40fs2x4.cloudfront.net/2017-08-21/files/landscape-photography_1645.jpg"));
    if (response.statusCode != 200) {
      debugPrint('Failed to download image: ${response.statusCode}');
      return null;
    }

    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/image.jpg';

    // Save the image to the file
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(file.path);

    int width = properties.width!;
    int height = properties.height!;
    log("w: $width -- h: $height");

    debugPrint('Image saved to: $filePath');
    return filePath;
  }

  @override
  initState() {
    super.initState();
    downloadAndSaveImage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: '),
        ),
      ),
    );
  }
}
