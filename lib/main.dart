import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_books_app/res/MyColors.dart';
import 'package:flutter_books_app/ui/splash/splashPage.dart';

void main() {
  runApp(MyApp());

  //设置状态栏透明
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: MyColors.primary,
        secondaryHeaderColor: MyColors.textPrimaryColor,
        scaffoldBackgroundColor: MyColors.white,
      ),
      home: SplashPage(),
    );
  }
}
