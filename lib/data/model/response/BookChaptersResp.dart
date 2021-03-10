//
//  BookChaptersResp
//  flutter_books_app
//
//  Created by jsjzx on 2020-03-14.
//  Copyright © 2020 All rights reserved.
//

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert' show json;

part 'BookChaptersResp.g.dart';


class BookChaptersResp {

  @JsonKey(name: "_id")
  String id;
  String book;
  String host;
  String link;
  String name;
  String source;
  String updated;
  List<BookChaptersBean> chapters;

  BookChaptersResp.fromParams({this.id, this.book, this.host, this.link, this.name, this.source, this.updated, this.chapters});

  factory BookChaptersResp(jsonStr) => jsonStr == null ? null : jsonStr is String ? new BookChaptersResp.fromJson(json.decode(jsonStr)) : new BookChaptersResp.fromJson(jsonStr);

  BookChaptersResp.fromJson(jsonRes) {
    id = jsonRes['_id'];
    book = jsonRes['book'];
    host = jsonRes['host'];
    link = jsonRes['link'];
    name = jsonRes['name'];
    source = jsonRes['source'];
    updated = jsonRes['updated'];
    chapters = jsonRes['chapters'] == null ? null : [];

    for (var chaptersItem in chapters == null ? [] : jsonRes['chapters']){
      chapters.add(chaptersItem == null ? null : new BookChaptersBean.fromJson(chaptersItem));
    }
  }
}

@JsonSerializable()

class BookChaptersBean {

  int currentcy;
  int order;
  int partsize;
  int time;
  int totalpage;
  bool unreadble;
  String chapterCover;
  String id;
  String link;
  String title;

  BookChaptersBean(this.currentcy, this.order, this.partsize, this.time, this.totalpage, this.unreadble, this.chapterCover, this.id, this.link, this.title);
  factory BookChaptersBean.fromJson(Map<String, dynamic> json) => _$BookChaptersBeanFromJson(json);

  Map<String, dynamic> toJson() => _$BookChaptersBeanToJson(this);


}