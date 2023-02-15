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
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void addLike() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    print(favorites);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(
          'Homepage.',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: GeneratorPage(),
      ),
      drawer: Drawer(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 120,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Text(
                  'Views',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home_outlined,
                color: Colors.black,
              ),
              title: const Text('HomePage'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.favorite_border,
                color: Colors.black,
              ),
              title: const Text('FavoritesPage'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ));
              },
            ),
          ],
        ),
      ),
    );
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
          ElevatedCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.addLike();
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

class ElevatedCard extends StatelessWidget {
  const ElevatedCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 15,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 100,
          width: 300,
          child: Center(
            child: Text(
              pair.asLowerCase,
              semanticsLabel: pair.asPascalCase,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}


// class MyHomePage extends StatefulWidget {
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   var selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Homepage.'),
//       ),
//       body: Center(
//         child: GeneratorPage(),
//       ),
//       drawer: Drawer(
//         // Add a ListView to the drawer. This ensures the user can scroll
//         // through the options in the drawer if there isn't enough vertical
//         // space to fit everything.
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             SizedBox(
//               height: 120,
//               child: DrawerHeader(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                 ),
//                 child: Text(
//                   'Views',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(
//                 Icons.home_outlined,
//                 color: Colors.black,
//               ),
//               title: const Text('HomePage'),
//               onTap: () {
//                 Navigator.of(context).pushReplacement(MaterialPageRoute(
//                   builder: (context) => MyHomePage(),
//                 ));
//               },
//             ),
//             ListTile(
//               leading: const Icon(
//                 Icons.favorite_border,
//                 color: Colors.black,
//               ),
//               title: const Text('FavoritesPage'),
//               onTap: () {
//                 Navigator.of(context).pushReplacement(MaterialPageRoute(
//                   builder: (context) => MyHomePage(),
//                 ));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }