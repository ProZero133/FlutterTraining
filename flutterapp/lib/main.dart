import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mostrar_imagenes.dart';
import 'forms.widgets.dart' as forms_widgets;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: Consumer<MyAppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'Namer App',
            theme: appState.isDarkMode
                ? ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: Colors.blueGrey,
                      secondary: Colors.cyan,
                      surface: Colors.blueGrey[
                          800]!, // Reemplaza 'background' con 'surface'
                      error: Colors.red[400]!,
                      onPrimary: Colors.white,
                      onSecondary: Colors.white,
                      onSurface: Colors
                          .white, // Reemplaza 'onBackground' con 'onSurface'
                      onError: Colors.white,
                    ),
                  )
                : ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: const Color.fromARGB(255, 75, 16, 211),
                    ),
                  ),
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];
  bool isDarkMode = false;

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

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

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }

  void reorderFavorites(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final WordPair item = favorites.removeAt(oldIndex);
    favorites.insert(newIndex, item);
    notifyListeners();
  }

  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = forms_widgets.GridViewWidget();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter training'),
        actions: [
          Switch(
            value: appState.isDarkMode,
            onChanged: (value) {
              appState.toggleDarkMode();
            },
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Row(
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
                    icon: Icon(Icons.input),
                    label: Text('Input widgets'),
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
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.input),
            label: 'Input widgets',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class FavoritesPage extends StatefulWidget {
  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppState>(
      builder: (context, appState, child) {
        return ListView.builder(
          itemCount: appState.favorites.length,
          itemBuilder: (context, index) {
            return LongPressDraggable<WordPair>(
              data: appState.favorites[index],
              feedback: Material(
                child: FavoriteCard(
                  pair: appState.favorites[index],
                  onRemove: () {},
                ),
              ),
              childWhenDragging: Container(),
              child: DragTarget<WordPair>(
                onAcceptWithDetails: (details) {
                  final oldIndex = appState.favorites.indexOf(details.data);
                  appState.reorderFavorites(oldIndex, index);
                },
                builder: (context, candidateData, rejectedData) {
                  return FavoriteCard(
                    pair: appState.favorites[index],
                    onRemove: () {
                      appState.removeFavorite(appState.favorites[index]);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class FavoriteCard extends StatelessWidget {
  const FavoriteCard({
    super.key,
    required this.pair,
    required this.onRemove,
  });

  final WordPair pair;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    return InkWell(
      onTap: onRemove,
      child: Card(
        elevation: 30.0,
        shadowColor: Color.fromARGB(255, 247, 0, 255),
        color: theme.colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(pair.asLowerCase, style: style),
        ),
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
          Wrap(
            alignment: WrapAlignment.center,
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
    return Wrap(
      alignment: WrapAlignment.center, // Alinea los elementos en el centro
      spacing: 10.0, // Espacio horizontal entre elementos
      runSpacing: 10.0, // Espacio vertical entre líneas
      children: [
        FractionallySizedBox(
          widthFactor: 0.5, // Ocupa el 20% del ancho del contenedor padre
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Agregar palabra',
            ),
          ),
        ),
      ],
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
