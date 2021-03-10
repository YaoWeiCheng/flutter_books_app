//
//  BookInfoPage
//  flutter_books_app
//
//  Created by w on 2020-02-17
//  Copyright © 2020年 com.cyw All rights reserved.
//

/// 详情页

import 'package:flutter/material.dart';
import 'package:flutter_books_app/widget/LoadView.dart';
import 'package:flutter_books_app/db/DbHelper.dart';
import 'dart:async';
import 'package:flutter_books_app/event/EventBus.dart';
import 'package:flutter_books_app/res/MyColors.dart';
import 'package:flutter_books_app/res/dimens.dart';
import 'package:flutter_books_app/utils/Utils.dart';
import 'package:flutter_books_app/Widget/static_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_books_app/data/repository/Repository.dart';
import 'package:flutter_books_app/data/model/request/BookInfoResp.dart';
import 'package:flutter_books_app/ui/details/BookChaptersPage.dart';

class BookInfoPage extends StatefulWidget {

  final String _bookId;
  final bool _back;

  BookInfoPage(this._bookId, this._back);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BookInfoPageState();
  }
}

class BookInfoPageState extends State<BookInfoPage> implements OnLoadReloadListener {

  LoadStatus _loadStatus = LoadStatus.LAODING;
  BookInfoResp _bookInfoResp;
  ScrollController _controller = new ScrollController();
  Color _iconColor = Color.fromARGB(255, 255, 255, 255);
  Color _titleBgColor = Color.fromARGB(0, 255, 255, 255);
  Color _titleTextColor = Color.fromARGB(0, 0, 0, 0);
  bool _isDivierGrone = true;
  String _image;
  String _bookName;
  var _dpHelper = DbHelper();

  //判断是否加入书架
  bool _isAddBookshelf = false;
  BookShelfBean _bookShelfBean;
  StreamSubscription booksSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    booksSubscription = eventBus.on<BooksEvent>().listen((event) {
      print("监听触发");
       getDbData();
    });
    getData();

    _controller.addListener(() {
      var offset = _controller.offset;
      print(offset);
      if (offset <= 170 && offset >= 0) {
        setState(() {
          double num = (1 - offset / 170) * 255;
          _iconColor = Color.fromARGB(255, num.toInt(), num.toInt(), num.toInt());
          _titleBgColor = Color.fromARGB(255 - num.toInt(), 255, 255, 255);
          if (offset > 90) {
            _titleTextColor = Color.fromARGB(255 - num.toInt(), 0, 0, 0);
          } else {
            _titleTextColor = Color.fromARGB(0, 0, 0, 0);
          }
          if (offset > 160) {
            _isDivierGrone = false;
          } else {
            _isDivierGrone = true;
          }
        });
      } else {
        if (offset > 170) {
          setState(() {
            _isDivierGrone = false;
            _iconColor = Color.fromARGB(255, 0, 0, 0);
            _titleTextColor = Color.fromARGB(255, 0, 0, 0);
            _titleBgColor = Color.fromARGB(255, 255, 255, 255);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: MyColors.white,
      body: SafeArea(
          child: childLayout(),
      ),
    );
  }

  Widget childLayout() {

    if (_loadStatus == LoadStatus.LAODING) {
       return LoadView();
    }
    if (_loadStatus == LoadStatus.FAILURE) {
       return FailureView(this);
    }

    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        contentView(),
        titleView(),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: MaterialButton(
            height: Dimens.titleHeight,
            color: MyColors.textPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0))
            ),
            onPressed: () {
              print("点击了");
            },
            child: Text(
              _isAddBookshelf ? (_bookShelfBean.readProgress == 0 ? "开始阅读" : "继续阅读") : "开始阅读",
              style: TextStyle(color: MyColors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  // 标题view
  Widget titleView() {
    return Container(
      color: _titleBgColor,
      constraints: BoxConstraints.expand(height: Dimens.titleHeight),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    Dimens.leftMargin, 0, Dimens.rightMargin, 0
                  ),
                  child: Image.asset(
                    'images/icon_title_back.png',
                    color: _iconColor,
                    width: 20,
                    height: Dimens.titleHeight,
                  ),
                ),
              ),
            ),
          ),
          Text(
            _bookInfoResp.title,
            style: TextStyle(
              color: _titleTextColor,
              fontSize: Dimens.titleTextSize,
            ),
          ),
          Positioned(
            right: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                    print("点击了分享按钮");
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 0, Dimens.rightMargin, 0),
                  child: Image.asset(
                    'images/icon_share.png',
                    color: _iconColor,
                    width: 18,
                    height: Dimens.titleHeight,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Offstage(
              offstage: _isDivierGrone,
              child: Divider(height: 1, color: MyColors.dividerDarkColor,),
            ),
          ),
        ],
      ),
    );
  }


  //内容view
  Widget contentView() {
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          converView(),
          bodyView(),
          Container(
            height: 14,
            color: MyColors.dividerColor,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 20, Dimens.rightMargin, 20),
            child: Text(
              _bookInfoResp.longIntro,
              style: TextStyle(
                color: MyColors.black,
                fontSize: Dimens.textSizeM,
              ),
            ),
          ),
          Container(
            height: 14,
            color: MyColors.dividerColor,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 12, Dimens.rightMargin, 12),
            child: Row(
              children: <Widget>[
                Text(
                  "最新书评",
                  style: TextStyle(
                    fontSize: Dimens.textSizeM, color: MyColors.textBlack3
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(1, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      print("写书评了");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'images/icon_info_edit.png',
                          width: 16,
                          height: 16,
                        ),
                        Container(
                          width: 5,
                        ),
                        Text(
                          "写书评",
                          style: TextStyle(
                            fontSize: Dimens.textSizeL,
                            color: Color(0xFF33C3A5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          commentList(),
          GestureDetector(
            child: Container(
              child: Text(
                "查看更多评论（269）",
                style: TextStyle(
                  color: MyColors.textPrimaryColor,
                  fontSize: Dimens.textSizeL,
                ),
              ),
              padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
            ),
            onTap: () {
              print("点击了更多评论");
            },
          ),
          Container(
            alignment: Alignment.center,
            color: MyColors.dividerColor,
            child: Text(
              "" + _bookInfoResp.copyrightDesc,
              style: TextStyle(
                color: MyColors.textBlack9,
                fontSize: 12
              ),
            ),
            padding: EdgeInsets.fromLTRB(0, 14, 0, 68),
          ),
        ],
      ),

    );
  }
  //封面view
  Widget converView() {
    return Container(
      color: MyColors.infoBgColor,
      padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 68, Dimens.rightMargin, 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.network(
            Utils.convertImageUrl(_image),
            height: 137,
            width: 100,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max, //尽可能占用最大空间
              mainAxisAlignment: MainAxisAlignment.start, //表示子组件在Row所占用的水平空间内对齐方式，如果mainAxisSize值为MainAxisSize.min，则此属性无意义，因为子组件的宽度等于Row的宽度。只有当mainAxisSize的值为MainAxisSize.max时，此属性才有意义，MainAxisAlignment.start表示沿textDirection的初始方向对齐，如textDirection取值为TextDirection.ltr时，则MainAxisAlignment.start表示左对齐，textDirection取值为TextDirection.rtl时表示从右对齐。而MainAxisAlignment.end和MainAxisAlignment.start正好相反；MainAxisAlignment.center表示居中对齐。读者可以这么理解：textDirection是mainAxisAlignment的参考系。
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _bookName,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: Dimens.textSizeM, color: MyColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                    _bookInfoResp.author,
                  style: TextStyle(
                    fontSize: Dimens.textSizeM, color: MyColors.white,
                  ),
                ),
                SizedBox(
                  height: 61,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max, //尽可能获取最大空间
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _bookInfoResp.cat,
                      style: TextStyle(
                        fontSize: Dimens.textSizeL, color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(11, 0, 11, 0),
                      color: Color(0x50FFFFFF),
                      width: 1,
                      height: 12,
                      child: Text(""),
                    ),
                    Text(
                      getWordCount(_bookInfoResp.wordCount),
                      style: TextStyle(
                        fontSize: Dimens.textSizeL, color: MyColors.white
                      ),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 3, 4),
                      child: Text( //评分
                        _bookInfoResp.rating != null ? _bookInfoResp.rating.score.toStringAsFixed(1) : "7.8",
                        style: TextStyle(
                          color: MyColors.fractionColor,
                          fontSize: 23
                        ),
                      ),
                    ),
                    Text(
                      "分",
                      style: TextStyle(
                        color: MyColors.white, fontSize: Dimens.textSizeL
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 操作栏
  Widget bodyView() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
          bodyChildView(
            _isAddBookshelf
                ? 'images/icon_details_bookshelf_add.png'
                : 'images/icon_details_bookshelf.png',
            _isAddBookshelf ? "已在书架" : "加入书架",
            0
          ),
        bodyChildView('images/icon_details_chapter.png', _bookInfoResp.chaptersCount.toString() + "章", 1),
        bodyChildView('images/icon_details_reward.png', "支持作品", 2),
        bodyChildView('images/icon_details_download.png', '批量下载', 3),
      ],
    );
  }

  Widget bodyChildView(String img, String content, int tag) {
    return Expanded(
      flex: 1,
      child: new GestureDetector(
        onTap: () {
          if (tag == 0) {
            if (!_isAddBookshelf) {
              var bean = BookShelfBean(_bookName, _image, "0", "", this.widget._bookId, 0, 0, 0);
              _dpHelper.addBooksshelfItem(bean);
              this._bookShelfBean = bean;
              setState(() {
                _isAddBookshelf = true;
              });
              eventBus.fire(new BooksEvent());
            }
          }
          if (tag == 1) {
            // 章节目录
            Navigator.push(context, MaterialPageRoute(builder: (content) => BookChaptersPage(this.widget._bookId, _image, _bookName)));
          }
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                img,
                width: 34,
                height: 34,
                fit: BoxFit.contain, // 尽可能大，但是还在包含之内
              ),
              Text(
                content,
                style: TextStyle(
                  color: MyColors.textBlack3,
                  fontSize: Dimens.textSizeM,
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  // 评论列表
  Widget commentList() {
    return Padding(
      padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 0, Dimens.rightMargin, 0),
      child: Column(
        children: <Widget>[
          itemView("嘎嘎", "这本书写得真好，赶紧更新呀", 4, "9", true),
          itemView("嘎嘎", "这本书写得真好，赶紧更新呀", 4, "8", false),
          itemView("嘎嘎", "这本书写得真好，赶紧更新呀", 4, "6", true),
          itemView("嘎嘎", "这本书写得真好，赶紧更新呀", 4, "8", false),
          itemView("嘎嘎", "这本书写得真好，赶紧更新呀", 4, "8", true),
        ],
      ),
    );
  }

  Widget itemView(String name, String content, double rate, String likeNum, bool image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            new ClipOval(
              child: new SizedBox(
                width: 32,
                height: 32,
                child: new Image.asset("images/icon_default_avatar.png"),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Column(
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: Dimens.textSizeL,
                      color: MyColors.textBlack6,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: new StaticRatingBar(
                      size: 10,
                      rate: rate,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 14, 0, 14),
          child: Text(
            content,
            style: TextStyle(
              color: MyColors.textBlack3, fontSize: Dimens.textSizeL
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Text(
              "2020.03.05",
              style: TextStyle(
                color: MyColors.textBlack9,
                fontSize: 12,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            GestureDetector(
              child: image ? Image.asset(
                "images/icon_like_true.png",
                width: 18,
                height: 18,
              ) : Image.asset(
                "images/icon_like_false.png",
                width: 18,
                height: 18,
              ),
              onTap: () {
                Fluttertoast.showToast(msg: "点击了点赞按钮", fontSize: 14.0);
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(2, 0, 20, 0),
              child: Text(
                likeNum,
                style: TextStyle(
                  fontSize: 12,
                  color: MyColors.textBlack9,
                ),
              ),
            ),
            GestureDetector(
              child: Image.asset(
                "images/icon_comment.png",
                height: 18,
                width: 18,
              ),
              onTap: () {
                print("点击了评论");
              },
            ),
          ],
        ),
        SizedBox(
          height: 18,
        ),
      ],
    );
  }

  void getData() async {
    await Repository().getBookInfo(this.widget._bookId).then((json) {
      print('getDatal 操作');
      setState(() {
        _loadStatus = LoadStatus.SUCCESS;
        _bookInfoResp = BookInfoResp(json);
        _image = _bookInfoResp.cover;
        _bookName = _bookInfoResp.title;
      });
      getDbData();
    }).catchError((e) {
      print('getDatel error: ${e.toString()}');
      setState(() {
        _loadStatus = LoadStatus.FAILURE;
      });
    });
  }

  void getDbData() async {
    var list = await _dpHelper.queryBooks(_bookInfoResp.id);
    if (list != null) {
      _bookShelfBean = list;
      setState(() {
        _isAddBookshelf = true;
      });
    } else {
      setState(() {
        _isAddBookshelf = false;
      });
    }
  }


  String getWordCount(int wordCount) {
    if (wordCount > 10000) {
      return (wordCount / 10000).toStringAsFixed(1) + "万字";
    }
    return wordCount.toString() + "字";
  }
  @override
  void onRload() {
    // TODO: implement onRload
    setState(() {
      _loadStatus = LoadStatus.LAODING;
    });
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    booksSubscription.cancel();
  }
}
