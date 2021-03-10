//
//  AppHome
//  flutter_books_app
//
//  Created by jsjzx on 2020-01-09.
//  Copyright © 2020 All rights reserved.
//
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_books_app/ui/home/HomePage.dart';
import 'package:flutter_books_app/ui/bookshelf/BookShelfPage.dart';
import 'package:flutter_books_app/ui/My/MyPage.dart';
import 'package:flutter_books_app/res/dimens.dart';
import 'package:flutter/services.dart';
import 'package:flutter_books_app/res/MyColors.dart';
import 'package:flutter/services.dart';

class AppHomePage extends StatefulWidget {
  static const platform = const MethodChannel("samples.flutter.io/permission");

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AppHomePageState();
  }
}

class _AppHomePageState extends State {
  //tabBar选中索引
  int _tabIndex = 0;
  //tabBar图片
  final List<Image> _tabImages = [
    Image.asset('images/icon_tab_bookshelf_n.png', width: Dimens.homeImageSize,),
    Image.asset('images/icon_tab_bookshelf_p.png', width: Dimens.homeImageSize,),
    Image.asset('images/icon_tab_home_n.png', width: Dimens.homeImageSize,),
    Image.asset('images/icon_tab_home_p.png', width: Dimens.homeImageSize,),
    Image.asset('images/icon_tab_me_n.png', width: Dimens.homeImageSize,),
    Image.asset('images/icon_tab_me_p.png', width: Dimens.homeImageSize,),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 动态申请相机权限示例，原生部分请查看 Android 下的 MainActivity
//    _getPermission();
  }

  Future<Null> _getPermission() async {
    final String result = await AppHomePage.platform.invokeMethod('requestCameraPermissions');
    print("result=$result");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: IndexedStack(
        children: <Widget>[
          BookShelfPage(),
          HomePage(),
          MyPage(),
        ],
        index: _tabIndex,
      ),
      bottomNavigationBar: CupertinoTabBar( //设置TabBar
        items: [
          BottomNavigationBarItem(
            icon: _getBookShelfImage(0),
            title: Text('书架'),
          ),
          BottomNavigationBarItem(
            icon: _getHomePageImage(1),
            title: Text('书城'),
          ),
          BottomNavigationBarItem(
            icon: _getMyImage(2),
            title: Text('我的'),
          ),
        ],
        currentIndex: _tabIndex,
        backgroundColor: MyColors.white,
        activeColor: MyColors.homeTabText,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }

  Image _getBookShelfImage(int index) {
    if (_tabIndex == index) { //选中状态
      return _tabImages[1];
    } else { //默认状态
      return _tabImages[0];
    }
  }

  Image _getHomePageImage(int index) {
    if (_tabIndex == index) {//选中状态
      return _tabImages[3];
    } else {
      return _tabImages[2];
    }
  }

  Image _getMyImage(int index) {
    if (_tabIndex == index) {
      return _tabImages[5];
    } else {
      return _tabImages[4];
    }
  }
}