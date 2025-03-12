import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
class MostrarImagen extends StatefulWidget {
  @override
  _MostrarImagenState createState() => _MostrarImagenState();
}

class _MostrarImagenState extends State<MostrarImagen> {
  final List<String> _subdirectories = ['images', 'gifs', 'links'];
  final Map<String, List<String>> _assets = {
    'images': ['capi.png', 'hellLetLoose.png', 'tu-4.jpg'],
    'gifs': ['barotrauma-baro.gif', 'barotrauma-barotrauma-game.gif', 'kitty-cat.gif'],
  };

  List<String> _links = [];
  String? _selectedAsset;
  Uint8List? _uploadedImage;

  @override
  void initState() {
    super.initState();
    _loadLinks();
  }

  Future<void> _loadLinks() async {
    final String response = await rootBundle.loadString('assets/links/enlaces.json');
    final data = await json.decode(response);
    setState(() {
      _links = List<String>.from(data['links']);
      _selectRandomAsset();
    });
  }

  void _selectRandomAsset() {
    final random = Random();
    final subdirectory = _subdirectories[random.nextInt(_subdirectories.length)];
    if (subdirectory == 'links') {
      final link = _links[random.nextInt(_links.length)];
      setState(() {
        _selectedAsset = link;
        _uploadedImage = null;
      });
    } else {
      final assets = _assets[subdirectory]!;
      final asset = assets[random.nextInt(assets.length)];
      setState(() {
        _selectedAsset = 'assets/$subdirectory/$asset';
        _uploadedImage = null; 
      });
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _uploadedImage = result.files.first.bytes;
        _selectedAsset = null; // Reset selected asset
      });
    }
  }

  Future<http.Response> _fetchImage(String url) {
    return http.get(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _uploadedImage != null
            ? Image.memory(_uploadedImage!)
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
                              return Image.memory(snapshot.data!.bodyBytes);
                            }
                          }
                          return CircularProgressIndicator();
                        },
                      )
                    : Image.asset(_selectedAsset!),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _selectRandomAsset,
          child: Text('Cambiar Imagen'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('Subir Imagen'),
        ),
      ],
    );
  }
}