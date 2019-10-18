//
//  CategoryFactory.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/14.
//  Copyright © 2019年 2017yd. All rights reserved.
//
import CoreData
import Foundation
//懒汉式模式
final class CategoryFactory {
    var repository: Repository<VMCategory>
    var app: AppDelegate?
    private static var instance: CategoryFactory?
    //构造器
    private init(_ app: AppDelegate) {
        repository = Repository<VMCategory>(app)
        self.app = app
    }
    //获取实例
    static func getInstance(_ app: AppDelegate) -> CategoryFactory {
        if let obj = instance {
            return obj
        }else{
            let token = "net.lzzy.factory.category"
            DispatchQueue.once(token: token, block: {
                if instance == nil {
                    instance = CategoryFactory(app)
                }
            })
            return instance!
        }
    }
    //获取所有类别
    func getAllCategories() throws -> [VMCategory] {
        return try repository.get()
    }
    //添加类别
    func add(category: VMCategory) -> (Bool,String?) {
        do {
            if try repository.isEntityExists([VMCategory.colName], keyword: category.name!){
                return (false, "同样的类别已经存在")
            }
            repository.insert(vm: category)
            return (true, nil)
        } catch DataError.entityExistsError(let info) {
            return (false, info)
        } catch {
            return (false, error.localizedDescription)
        }
    }
    //接收图书分类
    func getBooksCountOfCategory(category id: UUID) -> Int? {
        do {
            return try BookFactory.getInstance(app!).getBooksOF(category: id).count
        } catch {
            return nil
        }
    }
    //模糊搜索类别
    func searchCategory(keyword: String) throws -> [VMCategory] {
        return try repository.getBy([VMCategory.colName], keyword: keyword)
    }
    //删除类别
    func removeCategory(category: VMCategory) throws -> (Bool,String?) {
        if let count = getBooksCountOfCategory(category: category.id){
            if count > 0 {
                return (false,"存在该类别图书，不能删除")
            }
        } else {
            return (false,"无法获取类别信息！")
        }
        do {
            try repository.delete(id: category.id)
            return (false, nil)
        } catch DataError.deleteEntityError(let info) {
            return (false, info)
        } catch {
            return (false, error.localizedDescription)
        }
    }
    //更新书籍
    func updateCategory(category: VMCategory) throws -> (Bool, String?) {
        do {
            if try repository.isEntityExists([VMCategory.colName], keyword: category.name!){
                return (false, "同样的类别已经存在")
            }
            try repository.update(vm: category)
            return (true, nil)
        } catch DataError.updateEntityError(let info) {
            return (false, info)
        } catch {
            return (false, error.localizedDescription)
        }
    }
}
//扩展调度队列
extension DispatchQueue {
    private static var _onceTracker = [String]()
    public class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
