//
//  Repository
//  flutter_books_app
//
//  Created by w on 2020-01-23
//  Copyright © 2020年 com.cyw All rights reserved.
//

import 'package:flutter_books_app/data/ret/DotUtils.dart';
import 'package:flutter_books_app/data/model/request/BookChaptersReq.dart';

class Repository {

  ///获取首页小说列表
  Future<Map> getCategories(queryParameters) async {
    return await DioUtils().request<String>(
      "/book/by-categories",
      queryParameters: queryParameters,
    );
  }

  ///获取详情
  Future<Map> getBookInfo(bookId) async {
    return await DioUtils().request<String>(
      "/book/$bookId",
    );
  }

  /// 小说正版源
  Future<Map> getBookGenuineSource(quryParameters) async {
    return await DioUtils().request<String>(
      "/btoc",
      queryParameters: quryParameters,
    );
  }

  /// 获取小说章节列表
  Future<Map> getBookChapters(bookId) async {
    return await DioUtils().request<String>(
      "/atoc/$bookId",
      queryParameters: BookChaptersReq("chapters").toJson(),
    );
  }
}