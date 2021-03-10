//
//  BookChaptersPage
//  flutter_books_app
//
//  Created by jsjzx on 2020-03-14.
//  Copyright © 2020 All rights reserved.
//
import 'package:flutter/material.dart';
import 'package:flutter_books_app/data/model/response/BookChaptersResp.dart';
import 'package:flutter_books_app/res/MyColors.dart';
import 'package:flutter_books_app/res/dimens.dart';
import 'package:flutter_books_app/data/model/request/GenuineSoureceReq.dart';
import 'package:flutter_books_app/data/repository/Repository.dart';
import 'package:flutter_books_app/data/model/response/BookGenuineSourceResp.dart';

class BookChaptersPage extends StatefulWidget {
  final String _bookId;
  final String _image;
  final String _bookName;
  BookChaptersPage(this._bookId, this._image, this._bookName);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BookChaptersPageState();
  }
}

class BookChaptersPageState extends State<BookChaptersPage> {

  List<BookChaptersBean> _listBean = [];
  bool isReversed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: titleView(),
      ),
      body: new ListView.separated(
          itemBuilder: (context, index) {
            return itemView(index);
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 0, 0, 0),
              child: Divider(height: 1, color: MyColors.dividerDarkColor,
              ),
            );
          },
          itemCount: _listBean.length
      ),
    );
  }

  Widget titleView() {
    return Container(
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
                  padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 0, Dimens.rightMargin, 0),
                  child: Image.asset(
                    'images/icon_title_back.png',
                    width: 20,
                    height: Dimens.titleHeight,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "目录",
                  style: TextStyle(
                      fontSize: Dimens.titleTextSize,
                      color: MyColors.textPrimaryColor
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  width: 4,
                ),
                Image.asset(
                  "images/icon_chapters_turn.png",
                  width: 15,
                  height: 15,
                ),
              ],
            ),
            onTap: () {

            },
          ),
        ],
      ),
    );
  }

  Widget itemView(int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
//          Navigator.push(context, MaterialPageRoute(builder: (context) {
//
//          }));
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 16, Dimens.rightMargin, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  "${index + 1}.  ",
                  style: TextStyle(
                    fontSize: 9,
                    color: MyColors.textBlack9,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  _listBean[index].title,
                  style: TextStyle(
                    fontSize: Dimens.textSizeM,
                    color: MyColors.textBlack9,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getData() async {

    GenuineSourceReq genuineSoureceReq = GenuineSourceReq('summary', this.widget._bookId);
    var entryPoint = await Repository().getBookGenuineSource(genuineSoureceReq.toJson());
    BookGenuineSourceResp bookGenuineSourceResp = BookGenuineSourceResp(entryPoint);
    if (bookGenuineSourceResp.data != null && bookGenuineSourceResp.data.length > 0) {
      print(bookGenuineSourceResp.data[0].id);
      await Repository().getBookChapters(bookGenuineSourceResp.data[0].id).then((json) {
        BookChaptersResp bookChaptersResp = BookChaptersResp(json);
        setState(() {
          print(bookChaptersResp.chapters);
          _listBean = bookChaptersResp.chapters;
        });
      }).catchError((e) {
        // 请求出错
        print(e.toString());
      });
    }
  }
}