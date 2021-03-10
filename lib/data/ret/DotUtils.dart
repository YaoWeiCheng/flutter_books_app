//
//  DotUtils
//  flutter_books_app
//
//  Created by w on 2020-01-23
//  Copyright © 2020年 com.cyw All rights reserved.
//

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DioUtils {
  static final DioUtils _singleton = DioUtils.init();
  static Dio _dio;
  static String baseUrl = "http://api.zhuishushenqi.com";
  //是否debug
  static bool _isDebug = true;

  //打开debug模式
  static void openDebug() {
    _isDebug = true;
  }

  DioUtils.init() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000 * 10,
      receiveTimeout: 10000 * 20,
    );
    _dio = Dio(options);
  }

  factory DioUtils() {
    return _singleton;
  }

  Future<Map> request<T>(
      String path, {
        String method = Method.get,
        queryParameters,
        Options options,
        CancelToken cancelToken,
      }) async {
      Response response = await _dio.request(
        path,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken,
      );
      _printHttpLog(response);
      if (response.statusCode == 200) {
        try {
          if (response.data is Map) {
              if (response.data["ok"] != null && !response.data["ok"] && response.data["msg"] != null && response.data["code"] != null) {
                Fluttertoast.showToast(msg: response.data["msg"], fontSize: 14.0);
                return Future.error(new DioError(
                  response: response,
                  error: response.data["msg"],
                  type: DioErrorType.RESPONSE,
                ));
              }
              return response.data;
          } else {
              if (response.data is List) {
                Map<String, dynamic> _dataMap = Map();
                _dataMap["data"] = response.data;
                return _dataMap;
              }
          }
        } catch (e) {
          Fluttertoast.showToast(msg: "网络连接不可用，请稍后重试", fontSize: 14.0);
          return Future.error(new DioError(
            response: response,
            error: "data parsing exception...",
            type: DioErrorType.RESPONSE,
          ));
        }
      }
      return new Future.error(new DioError(
       response: response,
          error: "statusCode: ${response.statusCode} ,server code",
        type: DioErrorType.RESPONSE
      ));

  }

  /// print Http Log.
  void _printHttpLog(Response response) {
    if (!_isDebug) {
      return;
    }
    try {
      print("-----------------Http Log Start -------------------" +
          "\n[StatusCode]:    " + response.statusCode.toString() +
          "\n[request]:    " + _getOptionsStr(response.request)
      );
      _printDataStr("reqdata", response.data);
      _printDataStr("queryParameters", response.request.queryParameters);
      _printDataStr("respones", response.data);
    } catch(e) {
      print("http Log error....");
    }

  }

  /// get options String
  String _getOptionsStr(RequestOptions options) {
    return "method:" + options.method + " baseUrl:" + options.baseUrl + " paths:" + options.path;
  }

  /// print data str
  void _printDataStr(String tag, Object value) {
    String da = value.toString();
    while (da.isNotEmpty) {
      if (da.length > 512) {
        print("[$tag  ]:   " + da.substring(0, 512));
        da = da.substring(512, da.length);
      } else {
        print("[$tag  ]:   " + da);
        da = "";
      }
    }
  }


  /// check Options.
  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }
}

class Method {
  static const String get  = "GET";
  static final String post = "POST";
  static final String put  = "PUT";
  static final String head = "HEAD";
  static final String delete = "DELETE";
  static final String patch = "PATCH";
}