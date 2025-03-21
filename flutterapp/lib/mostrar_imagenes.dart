import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MostrarImagen extends StatefulWidget {
  @override
  MostrarImagenState createState() => MostrarImagenState();
}

class MostrarImagenState extends State<MostrarImagen> {
  final List<String> _subdirectories = ['images', 'gifs'];
  final Map<String, List<String>> _assets = {
    'images': ['capi.png', 'hellLetLoose.png', 'tu-4.jpg'],
    'gifs': ['barotrauma-baro.gif', 'barotrauma-barotrauma-game.gif', 'kitty-cat.gif'],
  };

  String? _selectedAsset;
  Uint8List? _uploadedImage;

  @override
  void initState() {
    super.initState();
    _selectRandomAsset();
  }

  void _selectRandomAsset() {
    final random = Random();
    final subdirectory = _subdirectories[random.nextInt(_subdirectories.length)];
    final assets = _assets[subdirectory]!;
    final asset = assets[random.nextInt(assets.length)];
    setState(() {
      _selectedAsset = 'assets/$subdirectory/$asset';
      _uploadedImage = null;
    });
  }

  Future<http.Response> _fetchImage(String url) {
    return http.get(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final maxImageSize = screenSize.width * 0.2;

    return Column(
      children: [
        _uploadedImage != null
            ? Container(
                constraints: BoxConstraints(
                  maxWidth: maxImageSize,
                  maxHeight: maxImageSize,
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.memory(_uploadedImage!),
                ),
              )
            : _selectedAsset == null
                ? CircularProgressIndicator()
                : _selectedAsset!.startsWith('http')
                    ? FutureBuilder<http.Response>(
                        future: _fetchImage(_selectedAsset!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              return Container(
                                constraints: BoxConstraints(
                                  maxWidth: maxImageSize,
                                  maxHeight: maxImageSize,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Image.memory(snapshot.data!.bodyBytes),
                                ),
                              );
                            }
                          }
                          return CircularProgressIndicator();
                        },
                      )
                    : Container(
                        constraints: BoxConstraints(
                          maxWidth: maxImageSize,
                          maxHeight: maxImageSize,
                        ),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image.asset(_selectedAsset!),
                        ),
                      ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _selectRandomAsset,
          child: Text('Cambiar Imagen'),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}