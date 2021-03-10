//
//  GenuineSoureceReq
//  flutter_books_app
//
//  Created by jsjzx on 2020-03-14.
//  Copyright © 2020 All rights reserved.
//

class GenuineSourceReq {

  String view;
  String book;

  GenuineSourceReq(this.view, this.book);

  Map<String, dynamic> toJson() {
    return {
      'view': view,
      'book': book,
    };
  }

}
