import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'ShowDetailScreen.dart';

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
        .map((item) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ShowDetailScreen(showId: item['show_id'] ?? '',title: item['title']??'',),
                ),
              );
            },
            child: Container(
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
                ],
              ),
            )))
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
