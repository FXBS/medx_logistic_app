import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restaurant/presentation/screens/intro/intro_screen.dart';

import '../intro/intro_screen.dart'; // Import the IntroScreen if not already imported

class BannerScreen extends StatelessWidget {
  final List<String> imageUrls = [
    'Assets/Banner/banner1.jpg',
    'Assets/Banner/banner2.jpg',
    'Assets/Banner/banner3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Wrap the CarouselSlider with an Expanded widget
          Expanded(
            child: CarouselSlider(
              options: CarouselOptions(
                height: 500.0, // You can adjust the height as needed
                enableInfiniteScroll: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                pauseAutoPlayOnTouch: true,
              ),
              items: imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.asset(
                        url,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),

          // Add any other widgets or buttons as needed below the carousel
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => IntroScreen()),
              );
            },
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }
}