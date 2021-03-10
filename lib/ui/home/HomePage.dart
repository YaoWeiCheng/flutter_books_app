import 'package:flutter/material.dart';
import 'package:flutter_books_app/res/MyColors.dart';
import 'package:flutter_books_app/res/dimens.dart';
import 'package:flutter_books_app/Widget/LoadView.dart';
import 'package:flutter_books_app/ui/home/HomeTabListView.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 1, //flex参数为弹性系数，如果为0或null，则child是没有弹性的，即不会被扩伸占用的空间。如果大于0，所有的Expanded按照其flex的比例来分割主轴的全部空闲空间。
                    child: GestureDetector(
                      onTap: () {
                        print("搜索框");
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(12, 0, 0, 0),  //容器外补白
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10), //容器内补白
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: MyColors.homeGrey,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max, //表示Row在主轴(水平)方向占用的空间，默认是MainAxisSize.max，表示尽可能多的占用水平方向的空间，此时无论子widgets实际占用多少水平空间，Row的宽度始终等于水平方向的最大宽度；而MainAxisSize.min表示尽可能少的占用水平空间，当子组件没有占满水平剩余空间，则Row的实际宽度等于所有子组件占用的的水平空间；
                          children: <Widget>[
                            Image.asset(
                              "images/icon_home_search.png",
                              width: 15,
                              height: 15,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "搜索本地及网络书籍",
                              style: TextStyle(
                                color: MyColors.homeGreyText,
                                fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("分类点击了");
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "images/icon_classification.png",
                            width: 12,
                            height: 22,
                          ),
                          Text(
                            "分类",
                            style: TextStyle(
                              color: MyColors.textBlack6,
                              fontSize: 11
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              TabBar(
                labelColor: MyColors.homeTabText,
                unselectedLabelColor: MyColors.homeTabGreyText,
                labelStyle: TextStyle(fontSize: 16),
                labelPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                indicatorColor: MyColors.homeTabText,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 2,
                indicatorPadding: EdgeInsets.fromLTRB(0, 0, 0, 6),
                tabs: <Widget>[
                  Text("精选"),
                  Text("男生"),
                  Text("女生"),
                  Text("出版"),
                ],
              ),
              Divider(height: 1, color: MyColors.dividerDarkColor),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    HomeTableListView("male", "仙侠"),
                    HomeTableListView("male", "玄幻"),
                    HomeTableListView("female", "现代言情"),
                    HomeTableListView("press", "出版小说"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//
//  ${PACKAGE_NAME}
//  ${PROJECT_NAME}
//
//  Created by ${USER} on ${DATE}.
//  Copyright © ${YEAR} ${ORGANIZATION_NAME} All rights reserved.
//