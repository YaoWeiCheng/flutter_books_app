//
//  BookChaptersReq
//  flutter_books_app
//
//  Created by jsjzx on 2020-03-14.
//  Copyright © 2020 All rights reserved.
//


class BookChaptersReq {

  String view;
  BookChaptersReq(this.view);

  Map<String, dynamic> toJson() {
    return {
      'view': view,
    };
  }

}