//
//  Utils
//  flutter_books_app
//
//  Created by jsjzx on 2020-01-10.
//  Copyright © 2020 All rights reserved.
//
import 'package:flutter/material.dart';

class Utils {
  /// "/agent/http%3A%2F%2Fimg.1391.com%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F1505654%2F1505654_7a52c23c70c44e3ebaf027f09588d641.jpg%2F"
  /// 返回的图片 url 字符串有问题，需要截取
  ///
  static String convertImageUrl(String imageUrl) {
    if (imageUrl == null) {
      return "";
    }
    return imageUrl.replaceAll("%2F", "/").replaceAll("%3A", ":").substring(7);
  }

}