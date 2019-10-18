//
//  BookFactory.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation
//懒汉式模式
final class BookFactory {
    var repository: Repository<VMBook>
    var app: AppDelegate?
    private static var instance: BookFactory?
    //构造器
    private init(_ app: AppDelegate) {
        repository = Repository<VMBook>(app)
        self.app = app
    }
    //获取实例
    static func getInstance(_ app: AppDelegate) -> BookFactory {
        if let obj = instance {
            return obj
        }else{
            let token = "net.lzzy.factory.book"
            DispatchQueue.once(token: token, block: {
                if instance == nil {
                    instance = BookFactory(app)
                }
            })
            return instance!
        }
    }
    //获取所有书籍
    func getAllTheBooks() throws -> [VMBook] {
        return try repository.get()
    }
    //添加书籍
    func add(book: VMBook) -> (Bool,String?) {
        do {
            if try isBookExists(book: book){
                return (false, "图书已存在")
            }
            repository.insert(vm: book)
            return (true, nil)
        } catch DataError.entityExistsError(let info) {
            return (false, info)
        } catch {
            return (false, error.localizedDescription)
        }
    }
    func getBooksOF(category id: UUID) throws -> [VMBook] {
        return try repository.getExact([VMBook.colCategoryId], keyword: id.uuidString)
    }
    //根据关键词查询书籍
    func getBookBy(id: UUID) throws -> VMBook? {
        let books = try repository.getExact([VMBook.colId], keyword: id.uuidString)
        if books.count > 0 {
            return books[0]
        }
        return nil
    }
    //存在的书籍
    func isBookExists(book: VMBook) throws -> Bool {
        var match10 = false
        var match13 = false
        if let isbn10 = book.isbn10 {
            if isbn10.count > 0 {
                match10 = try repository.isEntityExists([VMBook.colIsBn10], keyword: isbn10)
            }
        }
        if let isbn13 = book.isbn13 {
            if isbn13.count > 0 {
                match13 = try repository.isEntityExists([VMBook.colIsBn13], keyword: isbn13)
            }
        }
        return match10 || match13
    }
    //模糊搜索
    func searchBooks(keyword: String) throws -> [VMBook] {
        let cols = [VMBook.colIsBn13,VMBook.colIsBn10,VMBook.colTitle,VMBook.colAuthor,VMBook.colPublisher,VMBook.colSummary]
        let books = try repository.getBy(cols, keyword: keyword)
        return books
    }
    //删除书籍
    func removeBook(id: UUID) throws -> (Bool,String?) {
        do {
            try repository.delete(id: id)
            return (true, nil)
        } catch DataError.deleteEntityError(let info) {
            return (false, info)
        } catch {
            return (false, error.localizedDescription)
        }
    }
    //更新书籍
    func updateBook(book: VMBook) throws -> (Bool, String?) {
        do {
            if try isBookExists(book: book){
                return (false, "图书已存在")
            }
            try repository.update(vm: book)
            return (true, nil)
        } catch DataError.updateEntityError(let info) {
            return (false, info)
        } catch {
            return (false, error.localizedDescription)
        }
    }
}
