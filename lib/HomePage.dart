import 'package:flutter/material.dart';
import 'package:starlight/FrontScreen.dart';

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavigationExample());
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  List navigationwidgets = <Widget>[
    FirstScreen(),
    Container(
      color: Colors.yellowAccent,
      alignment: Alignment.center,
      child: const Text('Page 2'),
    ),
    Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: const Text('Page 3'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },

        backgroundColor: Colors.black87,
        indicatorColor: Colors.blueAccent,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home,
            color: Colors.white,),
            icon: Icon(Icons.home_outlined,
            color: Colors.white,),
            label: '',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.bookmark_added,
              color: Colors.white,),
            icon: Icon(Icons.bookmark_add_rounded,
            color: Colors.white,),
            label: '',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_2_rounded,
            color: Colors.white,),
            icon: Icon(Icons.person_2_rounded,
            color: Colors.white,),
            label: '',
          ),
        ],
      ),
      body: navigationwidgets[currentPageIndex],
    );
  }
}
