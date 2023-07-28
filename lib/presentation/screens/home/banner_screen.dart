import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../themes/colors_frave.dart';
import '../intro/checking_login_screen.dart';


class BannerScreen extends StatefulWidget {
  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  final List<String> imageUrls = [
    'Assets/Banner/banner1.jpg',
    'Assets/Banner/banner2.jpg',
    'Assets/Banner/banner3.jpg',
  ];

  int _currentImageIndex = 0;
  CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Carousel Slider with Indicator Dots
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height,
              enableInfiniteScroll: false,
              autoPlay: false,
              onPageChanged: (index, _) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              viewportFraction: 1.0, // Display only one image at a time
            ),
            items: imageUrls.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                  child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                      url,
                      fit: BoxFit.fill,
                    ),
                  ),
                  );
                },
              );
            }).toList(),
          ),

          // Previous Button
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                if (_currentImageIndex > 0) {
                  _carouselController.previousPage();
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CheckingLoginScreen()),
                  );
                }
              },
              child: Text(
                'Skip',
                style: TextStyle(
                  color: ColorsFrave.secundaryColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Set the button background color as white
                side: BorderSide.none,
              ),
            ),
          ),


          // Next Button
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _currentImageIndex < imageUrls.length - 1
                  ? () {
                _carouselController.nextPage();
              }
                  : () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CheckingLoginScreen()),
                );
              },
              child: Text(_currentImageIndex < imageUrls.length - 1
                  ? 'Next'
                  : 'Get Started',
                style: TextStyle(
                  color: ColorsFrave.secundaryColor, // Set the text color here
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Set the button background color as transparent
                side: BorderSide.none,
              ),
            ),
          ),

          // Indicator Dots
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageUrls.map((url) {
                int index = imageUrls.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin:
                  EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentImageIndex == index
                        ? ColorsFrave.secundaryColor
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}