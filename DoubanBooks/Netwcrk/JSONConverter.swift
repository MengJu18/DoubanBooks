//
//  JSONConverter.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/29.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation
class JSONConverter<T:JSONable>{
    static func getArray(jsonArray:Array<Any>)->[T]{
        var array = [T]()
        for json in jsonArray {

            let t = T(josn: json as! Dictionary<String, Any>)
            array.append(t)
        }
        return array
    }
    ///解析格式为["key":[{},{}...],"key":"xxx"...]的json数据
    ///-Parameter json:json数据
    ///-Parameter key:包含[{},{}...]的数据
    ///-Retuens:JSONable对象集合
    static func getArray(json:Any,key:String)->[T]{
        var array = [T]()
        let dic = json as! Dictionary<String,Any>
        let jsonArray = dic[key] as! Array<Any>
        for j in jsonArray {
            let t = T(josn: j as! Dictionary<String, Any>)
            array.append(t)
        }
        return array
    }
    static func getSingle(json: Any)-> T{
       return  T(josn:json as! Dictionary<String, Any>)
        
    }
    static func getSingle(json: Any,key:String)-> T{
        let t = json as! Dictionary<String,Any>
        let a = t [key] as! Dictionary<String,Any>
        return T (josn: a)

    }
//    static func extractUsefuljson(json:String)->String{
//        return ""
//    }
}
