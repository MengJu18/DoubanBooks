//
//  BookRepository.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation

class  BookRepository<T: DataViewModelDelegate> where T:NSObject{
    var app: AppDelegate
    var context: NSManagedObjectContext
    //构造器
    init(_ app:AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    //新增持久化数据
    func insert(vm: T) {
        let descruotuib = NSEntityDescription.entity(forEntityName: T.entityName, in: context)
        let book = NSManagedObject(entity: descruotuib!, insertInto: context)
        for (key, value) in vm.entityPairs() {
            book.setValue(value, forKey: key)
        }
        app.saveContext()
    }
    //存在的持久化数据
    func isExists(isBn: String) throws -> Bool {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "\(VMBook.colIsBn10) = %@ || \(VMBook.colIsBn13) = %@ ", isBn,isBn)
        do {
            let result = try context.fetch(fetch) as! [VMBook]
            return result.count > 0
        } catch {
            throw DataError.entityExistsError("判断存在的数据失败")
        }
    }
    //收到持久化数据
    func get() throws -> [VMBook] {
        var category = [VMBook]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        do {
            let result = try context.fetch(fetch) as! [VMBook]
            for c in result {
                let vm = VMBook()
                vm.id = c.id
                vm.categoryId = c.categoryId
                vm.author = c.author
                vm.pubdate = c.pubdate
                vm.image = c.image
                vm.pages = c.pages
                vm.publisher = c.publisher
                vm.isbn10 = c.isbn10
                vm.isbn13 = c.isbn13
                vm.title = c.title
                vm.author_intro = c.author_intro
                vm.summary = c.summary
                vm.price = c.price
                vm.binding = c.binding
                category.append(vm)
            }
        } catch {
            throw DataError.readCollectionError("读取集合数据失败")
        }
        return category
    }
    //按关键字来搜索
    func getByKeyword(keyword format:String, args: [Any]?) throws -> [VMBook] {
        var books = [VMBook]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do {
            let result = try context.fetch(fetch) as! [VMBook]
            for c in result {
                let vm = VMBook()
                vm.id = c.id
                vm.categoryId = c.categoryId
                vm.author = c.author
                vm.pubdate = c.pubdate
                vm.image = c.image
                vm.pages = c.pages
                vm.publisher = c.publisher
                vm.isbn10 = c.isbn10
                vm.isbn13 = c.isbn13
                vm.title = c.title
                vm.author_intro = c.author_intro
                vm.summary = c.summary
                vm.price = c.price
                vm.binding = c.binding
                books.append(vm)
            }
            return books
        } catch {
            throw DataError.readCollectionError("按关键字来搜索数据失败")
        }
    }
    //修改持久化数据
    func update(vm: VMBook) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do {
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
            obj.setValue(vm.id, forKey: VMBook.colId)
            obj.setValue(vm.categoryId, forKey: VMBook.colCategoryId)
            obj.setValue(vm.author, forKey: VMBook.colAuthor)
            obj.setValue(vm.pubdate, forKey: VMBook.colPubdate)
            obj.setValue(vm.image, forKey: VMBook.colImage)
            obj.setValue(vm.pages, forKey: VMBook.colPages)
            obj.setValue(vm.publisher, forKey: VMBook.colPublisher)
            obj.setValue(vm.isbn10, forKey: VMBook.colIsBn10)
            obj.setValue(vm.isbn13, forKey: VMBook.colIsBn13)
            obj.setValue(vm.title, forKey: VMBook.colTitle)
            obj.setValue(vm.author_intro, forKey: VMBook.colAuthor_Intro)
            obj.setValue(vm.summary, forKey: VMBook.colSummary)
            obj.setValue(vm.price, forKey: VMBook.colPrice)
            obj.setValue(vm.binding, forKey: VMBook.colBinding)
            app.saveContext()
        } catch {
            throw DataError.updateEntityError("修改图书数据失败")
        }
    }
    //删除持久化数据
    func delete(id:UUID) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMBook.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let result = try context.fetch(fetch)
            for b in result{
                context.delete(b as! NSManagedObject)
            }
            app.saveContext()
        } catch {
            throw DataError.deleteEntityError("删除图书数据失败")
        }
    }
}
