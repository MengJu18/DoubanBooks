//
//  Repository.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/15.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation
//使用协议来约束T
class Repository<T: DataViewModelDelegate> where T:NSObject {
    var app: AppDelegate
    var context: NSManagedObjectContext
    //构造器
    init(_ app:AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    /// 保存视图模型对象到数据库
    ///
    /// - parameter vm: 视图模型对象
    //通用的新增持久化数据
    func insert(vm: T) {
        let descruotuib = NSEntityDescription.entity(forEntityName: T.entityName, in: context)
        let obj = NSManagedObject(entity: descruotuib!, insertInto: context)
        for (key, value) in vm.entityPairs() {
            obj.setValue(value, forKey: key)
        }
        app.saveContext()
    }
    /// 根据条件判断实体类是否存在
    ///
    /// - parameter cols: 查询条件要比配的列
    //通用的存在的持久化数据
    func isEntityExists(_ cols: [String], keyword: String) throws -> Bool {
        var format = ""
        var args = [String]()
        for col in cols {
            format += "\(col) = %@ || "
            args.append(keyword)
        }
        format.removeLast(3)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do {
            let result = try context.fetch(fetch)
            return result.count > 0
        } catch {
            throw DataError.entityExistsError("判断存在的数据失败")
        }
    }
    /// 从本地数据库读取某一实体类全部数据
    ///
    /// - returns: 视图模型对象集合
    //收到持久化数据
    func get() throws -> [T] {
        var items = [T]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        do {
           let result = try context.fetch(fetch)
            for c in result {
                let vm = T()
                vm.packageSelf(result: c as! NSFetchRequestResult)
                items.append(vm)
            }
            return items
        } catch {
            throw DataError.readCollectionError("读取集合数据失败")
        }
    }
    /// 根据关键词查询某一实体类符合条件的数据，模糊查询
    ///
    /// - parameter cols: 需要比配的列如: ["name","publisher"]
    /// - parameter keyword: 要搜索的关键词
    /// - returns: 视图模型对象集合
    //按关键字来模糊搜索
    func getBy(_ cols: [String], keyword: String) throws -> [T] {
        var items = [T]()
        var format = ""
        var args = [String]()
        for col in cols {
            format += "\(col) like[c] = %@ || "
            args.append("*\(keyword)*")
        }
        format.removeLast(3)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do {
            let result = try context.fetch(fetch)
            for c in result {
                let vm = T()
                vm.packageSelf(result: c as! NSFetchRequestResult)
                items.append(vm)
            }
            return items
        } catch {
            throw DataError.readCollectionError("按关键字来搜索数据失败")
        }
    }
    /// 根据关键词查询某一实体类符合条件的数据，精确查询
    ///
    /// - parameter cols: 需要比配的列如: ["name","publisher"]
    /// - parameter keyword: 要搜索的关键词
    /// - returns: 视图模型对象集合
    //按关键字来精确搜索
    func getExact(_ cols: [String], keyword: String) throws -> [T] {
        var items = [T]()
        var format = ""
        var args = [String]()
        for col in cols {
            format += "\(col) = %@ || "
            args.append(keyword)
        }
        format.removeLast(3)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do {
            let result = try context.fetch(fetch)
            for c in result {
                let vm = T()
                vm.packageSelf(result: c as! NSFetchRequestResult)
                items.append(vm)
            }
            return items
        } catch {
            throw DataError.readCollectionError("按关键字来搜索数据失败")
        }
    }
    /// 修改数据
    ///
    /// - parameter vm: 视图模型对象集合
    //修改持久化数据
    func update(vm: T) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do {
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
            for (key, value) in vm.entityPairs() {
                obj.setValue(value, forKey: key)
            }
            app.saveContext()
        } catch {
            throw DataError.updateEntityError("修改图书数据失败")
        }
    }
    /// 删除数据
    ///
    /// - parameter id: 要删除数据的id
    //删除持久化数据
    func delete(id:UUID) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let result = try context.fetch(fetch)
            context.delete(result as! NSManagedObject)
            app.saveContext()
        } catch {
            throw DataError.deleteEntityError("删除图书数据失败")
        }
    }
}
