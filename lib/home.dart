import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import 'dbpokemon.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final picker = ImagePicker();
  File _image;
  bool _loading = false;
  List _output;

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

  @override
  void initState() {
    _loading = true;
    super.initState();
    loadModel().then((value) {
      //set state
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);

    setState(() {
      _loading = false;
      _output = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model.tflite', labels: 'assets/labels.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: _loading
                    ? Container(
                        width: 300,
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/pokeball.png'),
                            SizedBox(height: 50),
                          ],
                        ),
                      )
                    : Container(
                        child: Column(
                        children: <Widget>[
                          Container(
                            height: 250,
                            child: Image.file(_image),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _output != null
                              ? Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text('${_output[0]['label']}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20.0)),
                                )
                              : Container(),
                        ],
                      )),
              ),
            ],
          ),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton.extended(
            onPressed: () {
              pickImage();
            },
            label: const Text('Identify'),
            icon: const Icon(Icons.add_a_photo),
            backgroundColor: Colors.blueAccent,
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              // Buscar en la base de datos de los pokemons ya indentificados
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DbPokemon()));
            },
            label: const Text('Search'),
            icon: const Icon(Icons.search),
            backgroundColor: Colors.blueAccent,
          ),
        ]));
  }
}
