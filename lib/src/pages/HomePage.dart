import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  final picker = ImagePicker();
  final TextRecognizer _cloudRecognizer = FirebaseVision.instance.cloudTextRecognizer();
  // FirebaseApp defaultApp;
  bool _initialized = false;
  bool _error = false;

  //ML
  dynamic _scanResults;
  // Size? _imageSize;

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.info_outline),
        title: Text('Text Extractor'),
        
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _showPic(),
              SizedBox(height: 50),
              _buttons(context),
              
              Padding(
                padding: const EdgeInsets.only(left: 350.0,top: 250),
                child: FloatingActionButton(
                  child: Icon(Icons.camera_alt_rounded),
                  onPressed: _takePicture,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showPic() {
    if (_image == null) {
      return Image(
        image: AssetImage('assets/no-image.png'),
        height: 450,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        _image,
        height: 450.0,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 30),
        Expanded(
            child: ElevatedButton(
                onPressed: () => _recognizeText(context), child: Text('Get Text'))),
        SizedBox(width: 30),
        Expanded(
            child:
                ElevatedButton(onPressed: _clearImage, child: Text('Clear'))),
        SizedBox(width: 30)
      ],
    );
  }

  void _takePicture() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _recognizeText(BuildContext context) {
    if (_image != null) {
      _scanImage(context);
    }
  }

  void _clearImage() {
    setState(() {
      _image = null;
    });
  }

  showText(BuildContext context, String msj) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Text From Pic!'),
          content: 
          Container(
            height: MediaQuery.of(context).size.height/3,
                      child: SingleChildScrollView(
              child: Text(msj),
            ),
          ) ,
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(), child: Text('OK'))
          ],
        );
      },
    );
  }

  Future<void> _scanImage(BuildContext context) async {
    String textFromPic = '';
    setState(() {
      _scanResults = null;
    });
    final FirebaseVisionImage visionImage =FirebaseVisionImage.fromFile(_image);
    dynamic results;
    results = await _cloudRecognizer.processImage(visionImage);
    String text = results.text;
    for (TextBlock block in results.blocks) {
      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
          print(element.text);
          textFromPic = textFromPic + element.text+'\n';
        }
      }
    }
    showText(context, textFromPic);
    setState(() {
      _scanResults = results;
    });
  }

  @override
  void dispose() {
    _cloudRecognizer.close();
    super.dispose();
  }
}
