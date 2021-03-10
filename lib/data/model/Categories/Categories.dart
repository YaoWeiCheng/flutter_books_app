//
//  Categories
//  flutter_books_app
//
//  Created by w on 2020-01-31
//  Copyright © 2020年 com.cyw All rights reserved.
//

import 'package:json_annotation/json_annotation.dart';

part 'Categories.g.dart';

@JsonSerializable()
class Categories {

  List<Books> books;

  bool ok;

  int total;

  Categories(this.books, this.ok, this.total,);
  factory Categories.fromJson(Map<String, dynamic> json) => _$CategoriesFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
/**
 *   //不同的类使用不同的mixin即可
    factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
    Map<String, dynamic> toJson() => _$UserToJson(this);
 * */

}


@JsonSerializable()
class Books {

  @JsonKey(name: '_id')
  String id;

  @JsonKey(name: 'allowMonthly')
  bool allowMonthly;
  //作者
  String author;

  int banned;

  String contentType;
  //图片
  @JsonKey(name: 'cover')
  String conver;

  String lastChapter;

  int latelyFollower;

  String majorCate;

  String minorCate;

  double retentionRatio;

  String shortIntro;

  String site;

  int sizetype;

  String superscript;

  List<String> tags;

  String title;

  Books(this.id, this.allowMonthly, this.author, this.banned, this.contentType, this.conver, this.lastChapter, this.latelyFollower, this.majorCate, this.minorCate, this.retentionRatio, this.shortIntro, this.site, this.sizetype, this.superscript, this.tags, this.title);

  factory Books.fromJson(Map<String, dynamic> srcJson) => _$BooksFromJson(srcJson);

}

