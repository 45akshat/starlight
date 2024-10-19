import 'package:flutter/material.dart';
import 'package:starlight/FrontScreen.dart';
import 'HomePage.dart';
import 'KidsFrontScreen.dart';



class KidsParentsOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Black background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('I am a',style: TextStyle(
              fontSize: 40,color: Colors.black,fontWeight: FontWeight.bold
            ),),
            Text('Select one that applies to you',style: TextStyle(
                fontSize: 20,color: Colors.black
            ),),
            Spacer(),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  NavigationExample(kidOrParent: 'kid',)),
                );
              },

              child: Container(
                height: MediaQuery.of(context).size.height*0.4,
                  width:  MediaQuery.of(context).size.width*0.9,
                  child: Image.asset('assets/img/child.png',fit: BoxFit.fill,))

            ),
            SizedBox(height: 30),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NavigationExample(kidOrParent: 'parent',)),
                );
              },
              child:Container(
                  height:  MediaQuery.of(context).size.height*0.4,
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Image.asset('assets/img/parent.png',fit: BoxFit.fill,))
              ),
          ],
        ),
      ),
    );
  }
}
