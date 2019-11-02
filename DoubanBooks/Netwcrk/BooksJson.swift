//
//  BooksJson.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/28.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
let json_tag_start = "start" //int
let json_tag_count = "count" //int
let json_tag_total = "total" //int
let json_tag_books = "books" //[]
let json_books_id = "id"
let json_books_categoryId = "categoryId"
let json_books_author = "author"
let json_books_pubdate = "pubdate"
let json_books_image = "image"
let json_books_pages = "pages" //string
let json_books_publisher = "publisher"
let json_books_isbn10 = "isbn10"
let json_books_isbn13 = "isbn13"
let json_books_title = "title"
let json_books_author_intro = "author_intro"
let json_books_summary = "summary"
let json_books_price = "price" //string
let json_books_binding = "binding"
class BooksJson{
    static func getSearchUrl(keyword:String,page:Int)->String{
        let url = "https://douban.uieee.com/v2/book/search?q=" + keyword + "&start" + String (page*20)
        return url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}


