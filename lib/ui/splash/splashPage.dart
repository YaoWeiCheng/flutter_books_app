import 'package:flutter/material.dart';
import 'package:flutter_books_app/ui/home/AppHomePage.dart';

class SplashPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    startHome();
  }

  startHome() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AppHomePage()
          ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Image.asset(
        "images/launch_image.png",
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }
}