//
//  ActionViewPickerDegates.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/11/7.
//  Copyright © 2019 2017yd. All rights reserved.
//

import Foundation

protocol PickerModelDelegate {
    var title: String{get}
    var value: Any{get}
}
protocol PickerItemSelectDelegate {
    func itemSelected(index: Int)
}
