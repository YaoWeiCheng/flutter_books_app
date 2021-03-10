//
//  LoadView
//  flutter_books_app
//
//  Created by jsjzx on 2020-01-18.
//  Copyright © 2020 All rights reserved.
//
import 'package:flutter/material.dart';
import 'package:flutter_books_app/res/MyColors.dart';

class LoadView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoadViewState();
  }
}

class _LoadViewState extends State<LoadView>
    with SingleTickerProviderStateMixin {  ///通过  SingleTickerProviderStateMixin 实现动画效果。

  List<String> _listImages = [
    "images/icon_load_1.png",
    "images/icon_load_2.png",
    "images/icon_load_3.png",
    "images/icon_load_4.png",
    "images/icon_load_5.png",
    "images/icon_load_6.png",
    "images/icon_load_7.png",
    "images/icon_load_8.png",
    "images/icon_load_9.png",
    "images/icon_load_10.png",
    "images/icon_load_11.png",
  ];

  Animation<int> _animation;
  AnimationController _animationController;
  int _postion = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //定义一个动画控制器
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    //定义动画范围值 这里的0到10位刚好对应11张图片
    _animation = IntTween(begin: 0, end: 10).animate(_animationController)
      ..addListener(() { //它可以用于给Animation添加帧监听器，在每一帧都会被调用。帧监听器中最常见的行为是改变状态后调用setState()来触发UI重建。
        if (_postion != _animation.value) {//这里可以拿到图片的索引
          setState(() {
            _postion = _animation.value;
          });
        }
      });
    
    _animation.addStatusListener((status) { //它可以给Animation添加“动画状态改变”监听器；动画开始、结束、正向或反向（见AnimationStatus定义）时会调用状态改变的监听器。
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    _animationController.forward();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      color: MyColors.homeGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            _listImages[_postion],
            width: 43,
            height: 43,
            gaplessPlayback: true, //true为是否显示旧图像，false为还是不显示内容
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();

  }
}

class FailureView extends StatefulWidget {
  final OnLoadReloadListener _listener;

  FailureView(this._listener);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FailureViewState();
  }
}

class _FailureViewState extends State<FailureView> {



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      color: MyColors.homeGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "images/icon_network_error.png",
            width: 150,
            height: 150,
          ),
          SizedBox(
            height: 14,
          ),
          Text(
            "咦？没网络啦～检查一下网络吧",
            style: TextStyle(fontSize: 12, color: MyColors.textBlack9),
          ),
          SizedBox(
            height: 25,
          ),
          MaterialButton(
            color: MyColors.textPrimaryColor,
            child: Text(
              "重新加载",
              style: TextStyle(
                color: MyColors.white,
                fontSize: 16,
              ),
            ),
            onPressed: () {
              this.widget._listener.onRload(); //重新加载
            },
            minWidth: 150,
            height: 43,
          ),
        ],
      ),
    );
  }
}

//用abstract 修饰一个类的话，表示该类为抽象类，抽象方法没有方法体，需要子类去实现
abstract class OnLoadReloadListener {
  void onRload();
}

//请求状态
enum LoadStatus {
  LAODING,
  SUCCESS,
  FAILURE,
}
