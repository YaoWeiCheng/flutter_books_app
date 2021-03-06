//
//  MyPage
//  flutter_books_app
//
//  Created by jsjzx on 2020-01-09.
//  Copyright © 2020 All rights reserved.
//
import 'package:flutter/material.dart';
import 'package:flutter_books_app/res/MyColors.dart';
import 'package:flutter_books_app/res/dimens.dart';

class MyPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyPageState();
  }
}

class _MyPageState extends State<MyPage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _headerView(),
                Stack( //层叠布局Stack允许子组件堆叠
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 120,
                      color: MyColors.meBgColor,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                            Dimens.leftMargin, 0, Dimens.rightMargin, 0),
                      child: Image.asset(
                        "images/icon_me_vip_bg.png",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          30, Dimens.leftMargin, 30, Dimens.rightMargin),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            "images/icon_me_vip.png",
                            width: 18,
                            height: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "开通会员",
                            style: TextStyle(
                              fontSize: 14,
                              color: MyColors.meTextColor,
                            ),
                          ),
                          Expanded(
                              child: Container(),
                          ),
                          Text(
                            "万本好书免费读",
                            style: TextStyle(
                              color: MyColors.meTextColor,
                              fontSize: 14
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Image.asset(
                            "images/icon_me_vip_right_arrow.png",
                            width: 16,
                            height: 16,
                            color: MyColors.meTextColor,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      color: MyColors.white,
                      child: Column(
                        children: <Widget>[
                          _childView(
                              "images/icon_me_account.png",
                              "我的账户",
                              "购买、充值记录",
                              true
                          ),
                          _childView(
                              "images/icon_me_task.png",
                              "我的任务",
                              "绑定手机送礼券",
                              false,
                          ),
                          _childView(
                              "images/icon_me_game.png",
                              "我的游戏",
                              "",
                              true
                          ),
                          Container(
                            height: 12,
                            color: MyColors.dividerColor,
                          ),
                          _childView(
                              "images/icon_me_gift.png",
                              "兑换中心",
                              "",
                              true
                          ),
                          _childView(
                              "images/icon_me_message.png",
                              "我的消息",
                              "10",
                              false
                          ),
                          _childView(
                              "images/icon_me_comment.png",
                              "我的评论",
                              "购买、充值记录",
                              true
                          ),
                          Container(
                            height: 12,
                            color: MyColors.dividerColor,
                          ),
                          _childView(
                              "images/icon_me_cloud.png",
                              "云书架",
                              "同步书籍至云端",
                              true
                          ),
                          _childView(
                              "images/icon_me_download.png",
                              "我的下载",
                              "",
                              true
                          ),
                          _childView(
                              "images/icon_me_read_record.png",
                              "最近阅读记录",
                              "",
                              true
                          ),
                          Container(
                            height: 12,
                            color: MyColors.dividerColor,
                          ),
                          _childView(
                              "images/icon_me_help.png",
                              "帮助与反馈",
                              "",
                              true
                          ),
                          _childView(
                              "images/icon_me_panda.png",
                              "关于Panda看书",
                              "",
                              true
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ),

    );
  }
  //头部UI
  Widget _headerView() {
    return Container( //组合类容器
      color: MyColors.meBgColor,
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                          Dimens.leftMargin, 20, Dimens.rightMargin, 20),
                    child: ClipOval(
                      child: new SizedBox(
                        width: 56,
                        height: 56,
                        child:
                              new Image.asset("images/icon_default_avatar.png"),
                      ),
                    ),
                  ),
                  Text(
                      "书友123",
                    style: TextStyle(
                      fontSize: Dimens.titleTextSize,
                      color: MyColors.white,
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Container(),
              ),
              InkWell(
                onTap: () {
                  print("点击了设置");
                },
                child: Padding(
                    padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 7, Dimens.rightMargin, 0),
                    child: new Image.asset(
                        "images/icon_me_setting.png",
                        width: 23,
                        height: Dimens.titleHeight,
                    ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //将空闲空间均匀地放在子类之间。
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "0",
                    style: TextStyle(
                      fontSize: Dimens.titleTextSize,
                      color: MyColors.white,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "熊猫币",
                    style: TextStyle(
                      fontSize: Dimens.textSizeL,
                      color: MyColors.white,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: Color(0x50FFFFFF),
                width: 1,
                height: 23,
                child: Text(""),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "100",
                    style: TextStyle(
                      fontSize: Dimens.titleTextSize,
                      color: MyColors.white,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "礼券",
                    style: TextStyle(
                      fontSize: Dimens.textSizeL,
                      color: MyColors.white,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: Color(0x50FFFFFF),
                width: 1,
                height: 23,
                child: Text(""),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "签到",
                    style: TextStyle(
                      fontSize: Dimens.titleTextSize,
                      color: MyColors.white
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "送礼券",
                    style: TextStyle(
                      fontSize: Dimens.textSizeL,
                      color: MyColors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  //列表ItemWidget
  Widget _childView(String image, String content, String message, bool isGray) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {

        },
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                Dimens.leftMargin, Dimens.leftMargin, Dimens.rightMargin, Dimens.rightMargin),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  image,
                  width: 23,
                  height: 23,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  content,
                  style: TextStyle(
                    color: MyColors.textBlack3,
                    fontSize: Dimens.textSizeM,
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  message,
                  style: TextStyle(
                    color: isGray ? MyColors.textBlack9 : MyColors.meRedTextColor,
                    fontSize: 13,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Image.asset(
                  "images/icon_me_arrow.png",
                  width: 14,
                  height: 14,
                ),
              ],
            ),
        ),
      ),
    );
  }

}