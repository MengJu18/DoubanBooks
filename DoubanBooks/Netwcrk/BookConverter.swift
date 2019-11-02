//
//  BookConverter.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/30.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
class BookConverter {
    static func getBooks(json:Any)->[VMBook]?{
        var books:[VMBook]?
        let dic = json as! Dictionary<String,Any>
        if dic[json_tag_count] as! Int>0 {
        books=JSONConverter<VMBook>.getArray(json: json, key: json_tag_books)
        }
        return books!
    }
    static func getBook(json: Any) ->VMBook?{
     return JSONConverter<VMBook>.getSingle(json: json)
    }
}
