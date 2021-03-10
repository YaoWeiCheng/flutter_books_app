//
//  HomeTabListView
//  flutter_books_app
//
//  Created by jsjzx on 2020-01-18.
//  Copyright © 2020 All rights reserved.
//
import 'package:flutter/material.dart';
import 'package:flutter_books_app/Widget/LoadView.dart';
import 'package:flutter_books_app/res/MyColors.dart';
import 'package:flutter_books_app/res/dimens.dart';
import 'package:flutter_books_app/utils/Utils.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_books_app/data/model/request/CategoriesReq.dart';
import 'package:flutter_books_app/data/repository/Repository.dart';
import 'package:flutter_books_app/data/model/Categories/Categories.dart';
import 'package:flutter_books_app/ui/details/BookInfoPage.dart';

class HomeTableListView extends StatefulWidget {
  final String major;
  final String gender;

  HomeTableListView(this.gender, this.major);

  @override
  State<StatefulWidget> createState() {
    return _HomeTableListViewState();
  }
}

class _HomeTableListViewState extends State<HomeTableListView> with AutomaticKeepAliveClientMixin implements OnLoadReloadListener {

  List<Books> _list = [];
  LoadStatus _loadStatus = LoadStatus.LAODING;
  List<String> _listImage = [
    "images/icon_swiper_1.png",
    "images/icon_swiper_2.png",
    "images/icon_swiper_3.png",
    "images/icon_swiper_4.png",
    "images/icon_swiper_5.png",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    if (_loadStatus == LoadStatus.LAODING) {
      return LoadView();
    }
    if (_loadStatus == LoadStatus.FAILURE) {
      return FailureView(this);
    }

    return ListView.builder(
      itemCount: _list.length + 1,
      itemBuilder: (context, postion) {
        if (postion == 0) {
          return _Swiper();
        }
        return _buildListViewItem(postion - 1);
      },
    );
  }

  //轮播图
  Widget _Swiper() {
    return Container(
      height: 180,
      child: Swiper(
        itemHeight: 180,
        itemCount: _listImage.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(top: 16, bottom: 10),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_listImage[index]),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          );
        },
        autoplayDisableOnInteraction: true, //交互时禁用自动播放
        onTap: (index) {
          print("选中：$index");
        },
        viewportFraction: 0.9, //窗口比例
        scale: 0.93, //缩放比例
        outer: true,
        autoplay: false,
        pagination: new SwiperPagination(
          alignment: Alignment.bottomCenter,
          builder: DotSwiperPaginationBuilder(
            activeColor: MyColors.textBlack6,
            color: MyColors.paginationColor,
            size: 5,
            activeSize: 5
          ),
        ),
      ),
    );
  }

  //列表
  Widget _buildListViewItem(int position) {
//    String imageUrl = Utils.convertImageUrl("");
    String conver = _list[position].conver;
    print("我这里是图片链接：${conver}");
    String imageUrl = Utils.convertImageUrl(conver);
    return InkWell(
      onTap: () {

        Navigator.push(context,
          new MaterialPageRoute(
              builder: (context) => BookInfoPage(_list[position].id, false)
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(Dimens.leftMargin, 12, Dimens.leftMargin, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              imageUrl,
              height: 99,
              width: 77,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _list[position].title,
                    style: TextStyle(color: MyColors.textBlack3, fontSize: 16),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    _list[position].shortIntro,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: MyColors.textBlack6, fontSize: 14),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _list[position].author,
                          style: TextStyle(
                            color: MyColors.textBlack9,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      _list[position].tags != null && _list[position].tags.length > 0 ? tagView(_list[position].tags[0]) : tagView('限免'),
                      _list[position].tags != null && _list[position].tags.length > 1 ? SizedBox(width: 4,) : SizedBox(),
                      _list[position].tags != null && _list[position].tags != null && _list[position].tags.length > 1 ? tagView(_list[position].tags[1]) : SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  } 
  //标签
  Widget tagView(String tag) {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      alignment: Alignment.center,
      child: Text(
        tag,
        style: TextStyle(color: MyColors.textBlack9, fontSize: 12),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        border: Border.all(width: 0.5, color: MyColors.textBlack9),
      ),
    );
  }


  void _getData() async {

    print('----------------' + this.widget.gender);
    print('----------------' + this.widget.major);

    CategoriesReq req = CategoriesReq();
    req.gender = this.widget.gender;
    req.major = this.widget.major;
    req.type = "hot";
    req.start = 0;
    req.limit = 40;

    await Repository().getCategories(req.toJson()).then((json) {
      var resp = Categories.fromJson(json);
      setState(() {
        _loadStatus = LoadStatus.SUCCESS;
        _list = resp.books;
      });
    }).catchError((e) {
      setState(() {
        _loadStatus = LoadStatus.FAILURE;
      });
      print("错误： ${e.toString()}");
    });

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void onRload() {
    // TODO: implement onRload
    setState(() {
      _loadStatus = LoadStatus.LAODING;
    });
    _getData();
  }


}


