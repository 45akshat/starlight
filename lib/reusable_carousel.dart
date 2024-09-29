import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomCarouselSlider extends StatelessWidget {
  final double aspectRatio;
  final List<Map<String, dynamic>> imgList;

  CustomCarouselSlider({
    required this.aspectRatio,
    required this.imgList,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              margin: EdgeInsets.all(0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      item['image_url'] ?? '',
                      fit: BoxFit.fitHeight,
                      height: 1000,
                    ),
                  )),
                  // Positioned(
                  //   bottom: 20.0,
                  //   left: 20.0,
                  //   right: 0.0,
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  //     child: SizedBox(
                  //       height: 40,  // Set the height here
                  //       width: 100,  // Set the width here
                  //       child: ElevatedButton(
                  //         onPressed: () {},
                  //         child: Text('Watch Now'),
                  //         style: ButtonStyle(
                  //           backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                  //           shape: MaterialStateProperty.all(
                  //             RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(16),
                  //             ),
                  //           ),
                  //           minimumSize: MaterialStateProperty.all(Size(100, 40)), // Set the minimum size to ensure width
                  //         ),
                  //       ),
                  //     ),
                  //   )
                  //
                  //
                  // ),
                ],
              ),
            ))
        .toList();
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 0.7,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        autoPlay: true,
      ),
      items: imageSliders,
    );
  }
}
