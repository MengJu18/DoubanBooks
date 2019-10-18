//
//  Book.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/12.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation

class VMBook: NSObject,DataViewModelDelegate{
    var id: UUID
    var categoryId: UUID?
    var author: String?
    var pubdate: String?
    var image: String?
    var pages: Int32?
    var publisher: String?
    var isbn10: String?
    var isbn13: String?
    var title: String?
    var author_intro: String?
    var summary: String?
    var price: String?
    var binding: String?

    override init() {
        id = UUID()
        categoryId = UUID()
    }
    func entityPairs() -> Dictionary<String, Any?> {
        var dic: Dictionary<String, Any?> = Dictionary<String, Any?>()
        dic[VMBook.colId] = id
        dic[VMBook.colCategoryId] = categoryId
        dic[VMBook.colAuthor] = author
        dic[VMBook.colPubdate] = pubdate
        dic[VMBook.colImage] = image
        dic[VMBook.colPages] = pages
        dic[VMBook.colPublisher] = publisher
        dic[VMBook.colIsBn10] = isbn10
        dic[VMBook.colIsBn13] = isbn13
        dic[VMBook.colTitle] = title
        dic[VMBook.colAuthor_Intro] = author_intro
        dic[VMBook.colSummary] = summary
        dic[VMBook.colPrice] = price
        dic[VMBook.colBinding] = binding
        return dic
    }
    func packageSelf(result: NSFetchRequestResult) {
        let book = result as! Book
        id = book.id!
        categoryId = book.categoryId
        author = book.author
        pubdate = book.pubdate
        image = book.image
        pages = book.pages
        publisher = book.publisher
        isbn10 = book.isbn10
        isbn13 = book.isbn13
        title = book.title
        author_intro = book.author_intro
        summary = book.summary
        price = book.price
        binding = book.binding
    }
    static let entityName = "Book"
    static let colId = "id"
    static let colCategoryId = "categoryId"
    static let colAuthor = "author"
    static let colPubdate = "pubdate"
    static let colImage = "image"
    static let colPages = "pages"
    static let colPublisher = "publisher"
    static let colIsBn10 = "isbn10"
    static let colIsBn13 = "isbn13"
    static let colTitle = "title"
    static let colAuthor_Intro = "author_intro"
    static let colSummary = "summary"
    static let colPrice = "price"
    static let colBinding = "binding"
}
