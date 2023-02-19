import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: 'NamerApp',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 103, 39, 213)),
        ),
        debugShowCheckedModeBanner: false,
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

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void deleteFromFavorites(word) {
    if (favorites.contains(word)) {
      favorites.remove(word);
    }
    notifyListeners();
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
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
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

class GeneratorPage extends StatelessWidget {
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
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have ' '${appState.favorites.length} favorites:',
            style: TextStyle(
              fontSize: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        for (var pair in appState.favorites)
          Card(
            color: Theme.of(context).colorScheme.primary,
            child: ListTile(
              subtitle: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                        color: Theme.of(context).colorScheme.background,
                      ),
                      Text(
                        pair.asPascalCase,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.background,
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          appState.deleteFromFavorites(pair);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// Adding the drawer to Navbar, not completly correct.
// import 'package:english_words/english_words.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => MyAppState(),
//       child: MaterialApp(
//         title: 'NamerApp',
//         theme: ThemeData(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 103, 39, 213)),
//         ),
//         debugShowCheckedModeBanner: false,
//         home: MyHomePage(),
//       ),
//     );
//   }
// }

// class MyAppState extends ChangeNotifier {
//   var current = WordPair.random();
//   var favorites = <WordPair>[];

//   void getNext() {
//     current = WordPair.random();
//     notifyListeners();
//   }

//   void addLike() {
//     if (favorites.contains(current)) {
//       favorites.remove(current);
//     } else {
//       favorites.add(current);
//     }
//     print(favorites);
//     notifyListeners();
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     Widget page;
//     switch (selectedIndex) {
//       case 0:
//         page = GeneratorPage();
//         break;
//       case 1:
//         page = FavoritesPage();
//         break;
//       default:
//         throw UnimplementedError('no widget for $selectedIndex');
//     }

//     return LayoutBuilder(builder: (context, constraints) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//           title: Text(
//             'RandomNamer',
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         body: Center(
//           child: GeneratorPage(),
//         ),
//         drawer: Drawer(
//           backgroundColor: Theme.of(context).colorScheme.onSecondary,
//           // Add a ListView to the drawer. This ensures the user can scroll
//           // through the options in the drawer if there isn't enough vertical
//           // space to fit everything.
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               SizedBox(
//                 height: 112,
//                 child: DrawerHeader(
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.primaryContainer,
//                   ),
//                   child: Text(
//                     'Views',
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               Card(
//                 child: ListTile(
//                   leading: const Icon(
//                     Icons.home_outlined,
//                     color: Colors.black,
//                   ),
//                   title: const Text('HomePage'),
//                   tileColor: Theme.of(context).colorScheme.primaryContainer,
//                   onTap: () {
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                       builder: (context) => MyHomePage(),
//                     ));
//                   },
//                 ),
//               ),
//               Card(
//                 child: ListTile(
//                   leading: const Icon(
//                     Icons.favorite_border,
//                     color: Colors.black,
//                   ),
//                   title: const Text('FavoritesPage'),
//                   onTap: () {
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                       builder: (context) => FavoritesPage(),
//                     ));
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }

// class GeneratorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;

//     IconData icon;
//     if (appState.favorites.contains(pair)) {
//       icon = Icons.favorite;
//     } else {
//       icon = Icons.favorite_border;
//     }

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedCard(pair: pair),
//           SizedBox(height: 10),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   appState.addLike();
//                 },
//                 icon: Icon(icon),
//                 label: Text('Like'),
//               ),
//               SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   appState.getNext();
//                 },
//                 child: Text('Next'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FavoritesPage extends StatelessWidget {
//   const FavoritesPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var appstate = context.watch<MyAppState>();

//     if (appstate.favorites.isEmpty) {
//       return Center(
//         child: Text('No favorites yet.'),
//       );
//     }

//     return ListView(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Text('You have ' '${appstate.favorites.length} favorites: '),
//         ),
//         for (var pair in appstate.favorites)
//           ListTile(
//             leading: const Icon(
//               Icons.favorite,
//               color: Colors.black,
//             ),
//             title: Text(pair.asCamelCase),
//           ),
//       ],
//     );
//   }
// }

// class ElevatedCard extends StatelessWidget {
//   const ElevatedCard({
//     super.key,
//     required this.pair,
//   });

//   final WordPair pair;

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var style = theme.textTheme.displayMedium!.copyWith(
//       color: theme.colorScheme.onPrimary,
//     );

//     return Card(
//       color: theme.colorScheme.primary,
//       elevation: 15,
//       child: Padding(
//         padding: const EdgeInsets.all(5),
//         child: SizedBox(
//           height: 100,
//           width: 300,
//           child: Center(
//             child: Text(
//               pair.asLowerCase,
//               semanticsLabel: pair.asPascalCase,
//               style: style,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
