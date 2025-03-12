import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 58, 255, 58)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void customFavorite(String palabra) {
    favorites.add(WordPair(palabra, ' '));
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MyHomePage(),
            ),
          );
        },
        child: Text('Login'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = LoginPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 800,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.logout),
                    label: Text('Logout'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return ListView.builder(
      itemCount: appState.favorites.length,
      itemBuilder: (context, index) {
        return FavoriteCard(pair: appState.favorites[index]);
      },
    );
  }
}

class FavoriteCard extends StatelessWidget {
  const FavoriteCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      elevation: 30.0,
      shadowColor: Color.fromARGB(255, 247, 0, 255),
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}

class MiWidget extends StatelessWidget {
  final String text;

  const MiWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  final GlobalKey<_PalabraPersonalizadaState> _palabraPersonalizadaKey =
      GlobalKey<_PalabraPersonalizadaState>();
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PalabraPersonalizada(key: _palabraPersonalizadaKey),
              ElevatedButton(
                onPressed: () {
                  String palabra =
                      _palabraPersonalizadaKey.currentState?.getPalabra() ?? '';
                  appState.customFavorite(palabra);
                },
                child: Text('Agregar Favorito'),
              ),
            ],
          ),
          MiWidget(text: 'Texto de prueba'),
          MostrarImagen(),
        ],
      ),
    );
  }
}

class PalabraPersonalizada extends StatefulWidget {
  const PalabraPersonalizada({super.key});
  @override
  State<PalabraPersonalizada> createState() => _PalabraPersonalizadaState();
}

class _PalabraPersonalizadaState extends State<PalabraPersonalizada> {
  late TextEditingController controller;
  String palabra = '';
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(_updatePalabra);
  }

  void _updatePalabra() {
    setState(() {
      palabra = controller.text;
    });
  }

  @override
  void dispose() {
    controller.removeListener(_updatePalabra);
    controller.dispose();
    super.dispose();
  }

  String getPalabra() {
    return palabra;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: EdgeInsets.all(16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Palabra personalizada',
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return Card(
      elevation: 30.0,
      shadowColor: Color.fromARGB(255, 247, 0, 255),
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}


class MostrarImagen extends StatefulWidget {
  @override
  _MostrarImagenState createState() => _MostrarImagenState();
}

class _MostrarImagenState extends State<MostrarImagen> {
  final List<String> _subdirectories = ['images', 'gifs', 'links'];
  final Map<String, List<String>> _assets = {
    'images': ['capi.jpg', 'hellLetLoose.jpg', 'tu-4.jpg'],
    'gifs': ['barotrauma-baro.gif', 'barotrauma-barotrauma-game.gif', 'kitty-cat.gif'],
  };

  List<String> _links = [];
  String? _selectedAsset;

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
      });
    } else {
      final assets = _assets[subdirectory]!;
      final asset = assets[random.nextInt(assets.length)];
      setState(() {
        _selectedAsset = 'assets/$subdirectory/$asset';
      });
    }
  }

  Future<http.Response> _fetchImage(String url) {
    return http.get(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return _selectedAsset == null
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
            : Image.asset(_selectedAsset!);
  }
}
