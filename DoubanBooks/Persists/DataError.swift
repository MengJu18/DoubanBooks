//
//  DataError.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/12.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import Foundation

enum DataError:Error {
    case readCollectionError(String)    //
    case readSingleError(String)        //单独的抛出异常
    case entityExistsError(String)      //实体的抛出异常
    case deleteEntityError(String)      //删除的抛出异常
    case updateEntityError(String)      //修改的抛出异常
}
