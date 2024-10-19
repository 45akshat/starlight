import 'package:flutter/material.dart';
import 'package:starlight/AccountSettings.dart';
import 'package:starlight/CategoryPage.dart';
import 'package:starlight/FrontScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starlight/KidsFrontScreen.dart';



class NavigationExample extends StatefulWidget {
   NavigationExample({super.key,required this.kidOrParent});
  String kidOrParent;


  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {


  int currentPageIndex = 0;
  Color kidorparentcolor = Colors.blueAccent;

  List<Widget> navigationwidgets = [];

  @override
  void initState() {
    super.initState();
    // Initialize the list based on 'kidOrParent'
    if (widget.kidOrParent == 'kid') {
      kidorparentcolor =  Colors.deepOrangeAccent;
      navigationwidgets = [
        KidsScreen(),
        CategoryPage(text: 'Most Watched'),
        AccountSettingsScreen()
        // Add other widgets specific to 'kid'
      ];
    } else {
      kidorparentcolor =  Colors.blueAccent;
      navigationwidgets = [
       FirstScreen(),
        CategoryPage(text: 'Most Watched'),
        AccountSettingsScreen()
        // Add other widgets specific to 'parent'
      ];
    }
  }

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
        indicatorColor: kidorparentcolor,
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
