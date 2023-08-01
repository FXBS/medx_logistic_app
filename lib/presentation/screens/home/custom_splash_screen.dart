import 'package:flutter/material.dart';
import 'package:restaurant/presentation/screens/home/banner_screen.dart';
import 'package:video_player/video_player.dart';

class CustomSplashScreen extends StatefulWidget {
  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('Assets/splash_video.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
      });
    _navigateToBannerScreen();
  }

  void _navigateToBannerScreen() async {
    // Add any necessary delay or asynchronous tasks before navigating
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BannerScreen()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FittedBox(
          fit: BoxFit.cover, // This will scale the video to cover the available space
          child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
          ),
        ),
      ),
    );
  }
}
