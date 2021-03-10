//
//  DbHelper
//  flutter_books_app
//
//  Created by jsjzx on 2020-01-09.
//  Copyright © 2020 All rights reserved.
//

import 'package:sqflite/sqflite.dart'; //数据库
import 'package:path_provider/path_provider.dart'; //共享数据
import 'package:path/path.dart';
import 'dart:io';

class DbHelper {
  final String _tableName = "BookShelf";

  Database _db = null;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await _initDb();
    return _db;
  }

  _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "books.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    //创建表字段
    await db.execute("CREATE TABLE $_tableName("
        "id INTEGER PRIMARY KEY,"
        "title TEXT,"
        "image TEXT,"
        "readProgress TEXT,"
        "bookUrl TEXT,"
        "bookId TEXT,"
        "offset DOUBLE,"
        "isReversed INTEGER,"
        "chaptersIndex INTEGER)"
    );
    print("Created tables");
  }

  //查询加入书架的所有书籍
  Future<List> getTotalList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $_tableName");
    return result.toList();
  }

  /// 添加书籍到书架
  Future<int> addBooksshelfItem(BookShelfBean item) async {
    print("addBookshelfItem = ${item.bookId}");
    var dbClient = await db;
    int res =  await dbClient.insert("$_tableName", item.toMap());
    return res;
  }

  /// 根据 id 查询判断书籍是否存在书籍
  Future<BookShelfBean> queryBooks(String bookId) async {
    var dbClient = await db;
    var result = await dbClient.query(_tableName, where: "bookId = ?", whereArgs: [bookId]);
    if (result != null && result.length > 0) {
      return BookShelfBean.fromMap(result[0]);
    }
    return null;
  }

  //关闭数据库
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}


class BookShelfBean {

  BookShelfBean(this.title, this.image, this.readProgress, this.bookUrl, this.bookId, this.offset, this.isReversed, this.chaptersIndex);

  //书名
  String title;
  String image;
  String readProgress;
  String bookUrl;
  String bookId;
  double offset;

  //1是倒序
  int isReversed;
  int chaptersIndex;

  BookShelfBean.fromMap(Map<String, dynamic> map) {
    title = map["title"] as String;
    image = map["image"] as String;
    readProgress = map["readProgress"] as String;
    bookUrl = map["bookUrl"] as String;
    bookId = map["bookId"] as String;
    offset = map["offset"] as double;
    isReversed = map["isReversed"] as int;
    chaptersIndex = map["chaptersIndex"] as int;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      "title": title,
      "image": image,
      "readProgress": readProgress,
      "bookUrl": bookUrl,
      "bookId": bookId,
      "offset": offset,
      "isReversed": isReversed,
      "chaptersIndex": chaptersIndex,
    };
    return map;
  }
}