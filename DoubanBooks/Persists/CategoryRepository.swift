//
//  CategoryRepository.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/12.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation

class  CategoryRepository{
    var app: AppDelegate
    var context: NSManagedObjectContext
    //构造器
    init(_ app:AppDelegate) {
        self.app = app
        context = app.persistentContainer.viewContext
    }
    //新增持久化数据
    func insert(vm: VMCategory) {
        let descruotuib = NSEntityDescription.entity(forEntityName: VMCategory.entityName, in: context)
        let category = NSManagedObject(entity: descruotuib!, insertInto: context)
        category.setValue(vm.id, forKey: VMCategory.colId)
        category.setValue(vm.name, forKey: VMCategory.colName)
        category.setValue(vm.image, forKey: VMCategory.colImage)
        app.saveContext()
    }
    //存在的持久化数据
    func isExists(name: String) throws -> Bool {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "\(VMCategory.colName) = %@", name)
        do {
            let result = try context.fetch(fetch) as! [VMCategory]
            return result.count > 0
        } catch {
            throw DataError.entityExistsError("判断存在的数据失败")
        }
    }
    //收到持久化数据
    func get() throws -> [VMCategory] {
        var category = [VMCategory]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        do {
            let result = try context.fetch(fetch) as! [VMCategory]
            for c in result {
                let vm = VMCategory()
                vm.id = c.id
                vm.name = c.name
                vm.image = c.image
                category.append(vm)
            }
        } catch {
            throw DataError.readCollectionError("读取集合数据失败")
        }
        return category
    }
    //按关键字来搜索
    func getByKeyword(keyword format:String, args: [Any]?) throws -> [VMCategory]  {
        var category = [VMCategory]()
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: format, argumentArray: args)
        do {
            let result = try context.fetch(fetch) as! [VMCategory]
            for c in result {
                let vm = VMCategory()
                vm.id = c.id
                vm.name = c.name
                vm.image = c.image
                category.append(vm)
            }
            return category
        } catch {
            throw DataError.readCollectionError("按关键字来搜索数据失败")
        }
    }
    //修改持久化数据
    func update(vm: VMCategory) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", vm.id.uuidString)
        do {
            let obj = try context.fetch(fetch)[0] as! NSManagedObject
            obj.setValue(vm.id, forKey: VMCategory.colId)
            obj.setValue(vm.name, forKey: VMCategory.colName)
            obj.setValue(vm.image, forKey: VMCategory.colImage)
            app.saveContext()
        } catch {
            throw DataError.updateEntityError("修改类别数据失败")
        }
    }
    //删除持久化数据
    func delete(id:UUID) throws {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: VMCategory.entityName)
        fetch.predicate = NSPredicate(format: "id = %@", id.uuidString)
        do {
            let result = try context.fetch(fetch)
            for m in result{
                context.delete(m as! NSManagedObject)
            }
            app.saveContext()
        } catch {
            throw DataError.deleteEntityError("删除类别数据失败")
        }
    }
}
