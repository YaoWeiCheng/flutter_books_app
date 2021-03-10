//
//  BookShelfPage
//  flutter_books_app
//
//  Created by jsjzx on 2020-01-09.
//  Copyright © 2020 All rights reserved.
//
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_books_app/res/MyColors.dart';
import 'package:flutter_books_app/res/dimens.dart';
import 'package:flutter_books_app/db/DbHelper.dart';
import 'package:flutter_books_app/utils/Utils.dart';
import 'package:flutter_books_app/event/EventBus.dart';

class BookShelfPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BookShelfPageState();
  }
}

class _BookShelfPageState extends State<BookShelfPage> {
  var _dbHelper = DbHelper(); //数据库
  List<BookShelfBean> _listBean = []; //列表数据
  StreamSubscription booksSubscription; //监听事件
  final String _emptyTitle = "添加书籍";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    booksSubscription = eventBus.on<BooksEvent>().listen((event) {
      print("更新数据啦");
      getDbData();
    });
    //获取数据
    getDbData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            titleView(),
            Expanded( //可以按比例“扩伸” Row、Column和Flex子组件所占用的空间。
                child: SingleChildScrollView( //SingleChildScrollView类似于Android中的ScrollView，它只能接收一个子组件
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.fromLTRB(Dimens.leftMargin, 0, Dimens.rightMargin, 0),
                        padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                        decoration: BoxDecoration(
                          color: Color(0XFFEBF9F6),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        child: Text(
                          "【Panda看书】全网小说不限时免费观看",
                          style: TextStyle(
                            color: MyColors.textBlack6,
                            fontSize: Dimens.textSizeL,
                          ),
                        ),
                      ),
                      GridView.builder(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0), //填充
                        physics: NeverScrollableScrollPhysics(), //禁止滑动方法
                        shrinkWrap: true, //常用于内容大小不确定情况，如果滚动视图(ListView/GridView/ScrollView 等)没有收缩包装，则滚动视图将扩展到允许的最大大小；如果是无界约束，则 shrinkWrap 必须为 true。
                        itemCount: _listBean.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, //横轴元素数量
                          childAspectRatio: 0.5, // 宽高比为0.5，子widget
                        ),
                        itemBuilder: (context, index) {
                          return itemView(index);
                        },
                      ),
                    ],
                  ),
                ),
            ),

          ],
        ),
      ),
    );
  }

  Widget itemView(int index) {
    //是否阅读状态和进度
    String readProgress = _listBean[index].readProgress;
    if (readProgress == "0") {
      readProgress = "未读";
    } else {
      readProgress = "已读$readProgress%";
    }

    //添加书籍item
    bool addBookSelfItem = false;
    if (_listBean[index].title == _emptyTitle) { //当是添加书籍item时
      addBookSelfItem = true;
      readProgress = "";
    }

    //判断显示item的布局方式
    var position = index == 0 ? 0 : index % 3;
    var axisAlignment;
    //根据不同的索引调整书籍item为孩子，start靠左边靠拢，center中间靠拢，end靠右边靠拢
    if (position == 0) {
      axisAlignment = CrossAxisAlignment.start;
    } else if (position == 1) {
      axisAlignment = CrossAxisAlignment.center;
    } else if (position == 2) {
      axisAlignment = CrossAxisAlignment.end;
    }

    return Column(
      crossAxisAlignment: axisAlignment,
      children: <Widget>[
        Card( //接受单个widget，但该widget可以是Row，Column或其他包含子级别列表的widget 内容不能滚动
          shape: RoundedRectangleBorder( //画圆角
            borderRadius: BorderRadius.all(Radius.circular(3)), //设置圆角
          ),
          clipBehavior: Clip.antiAlias, //对widget截取的行为，比如这里Clip.antiAlias 指抗锯齿
          child: GestureDetector(
            child: addBookSelfItem
                ? Image.asset(
                "images/icon_bookshelf_empty_add.png",
                height: 121,
                width: 92,
                fit: BoxFit.cover,
            ) : Image.network(
              Utils.convertImageUrl(_listBean[index].image),
              height: 121,
              width: 92,
              fit: BoxFit.cover,
            ),
            onLongPress: () {
              if (!addBookSelfItem) {
                  print("我要删除小说啦～～～");
              }
            },
            onTap: () {
              if (addBookSelfItem) {
                print("添加小说");
              } else {
                print("看小说");
              }
              
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 96,
          child: Text(
            _listBean[index].title,
            maxLines: 2,
            style: TextStyle(
              fontSize: Dimens.textSizeM,
              color: addBookSelfItem ? MyColors.textBlack9 : MyColors.textBlack3,
            ),
          ),
        ),
        SizedBox(
          width: 96,
          child: Text(
            readProgress,
            style: TextStyle(
              fontSize: Dimens.textSizeL,
              color: MyColors.textBlack9
            ),
          ),
        ),
      ],
    );
  }

  //书架标题
  Widget titleView() {
    return Container(
      color: MyColors.primary,
      constraints: BoxConstraints.expand(height: Dimens.titleHeight), //约束条件
      padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 0, 0, 0), //填充 Padding可以给其子节点添加填充（留白），和边距效果类似
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
              '书架',
              style: TextStyle(
                fontSize: Dimens.titleTextSize,
                color: MyColors.textBlack3,
              ),
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(child: Container()),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
//                Navigator.push(context, Mater);
              print("hell word");
              },
              child: Padding(
                  padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 0, Dimens.rightMargin, 0),
                  child: Image.asset(
                    'images/icon_bookshelf_search.png',
                    width: 20,
                    height: Dimens.titleHeight,
                  ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Image.asset(
                  "images/icon_bookshelf_more.png",
                  width: 3.5,
                  height: Dimens.titleHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );


  }


  //从数据库中查询书架书籍
  void getDbData() async {
    await _dbHelper.getTotalList().then((list) {
      _listBean.clear();
      list.reversed.forEach((item) {
        BookShelfBean todoItem = BookShelfBean.fromMap(item);
        setState(() {
          _listBean.add(todoItem);
        });
      });
      setAddItem();
    });
  }

  // add item 样式设置
  void setAddItem() {
    BookShelfBean todoItem = BookShelfBean(_emptyTitle, null, "", "", "", 0, 0, 0);
    setState(() {
      _listBean.add(todoItem);
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    booksSubscription.cancel();
    _dbHelper.close();
  }

}