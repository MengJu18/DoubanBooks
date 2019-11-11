//
//  ActionViewPicker.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/11/7.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit

class ActionViewPicker<T: PickerModelDelegate>: UIView {
    let rowHeihgt = 60
    var onRect = UIScreen.main.bounds
    var offRect: CGRect = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        return CGRect(x: 0, y: h, width: w, height: h)
    }()
    
    var bgMask: UIView = {
        let mView = UIView()
        mView.backgroundColor = UIColor.lightGray
        mView.alpha = 0.5
        return mView
    }()
    
    var delegate: PickerItemSelectDelegate?
    
    fileprivate func addTitle(title: String, itemsCount: Int){
        let y = self.bounds.height - CGFloat(itemsCount * rowHeihgt + rowHeihgt + 20 + rowHeihgt + 10 + 2 )
        let lblTitle  = UILabel(frame: CGRect(x: 20, y: y, width: self.bounds.width - 40, height: CGFloat(rowHeihgt + 10)))
        lblTitle.textAlignment = .center
        lblTitle.backgroundColor = UIColor.white
        lblTitle.textColor = UIColor.black
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        lblTitle.text = title
        self.addSubview(lblTitle)
    }
    
    fileprivate func addItrms(_ itrms: [T]){
        var pos = 0
        for item in itrms {
            let btn = UIButton(type: .custom)
            let countOfBelow = itrms.count - pos
            let y = self.bounds.height - CGFloat(countOfBelow * rowHeihgt + rowHeihgt + 20)
            btn.frame = CGRect(x: 20, y: y, width: self.bounds.width - 40 , height: CGFloat(rowHeihgt))
            btn.backgroundColor = UIColor.white
            btn.tag = pos
            pos += 1
            btn.setTitle(item.title, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.addTarget(self, action:  #selector(itemSelected), for: .touchUpInside)
            let separator = UIView(frame: CGRect(x: 0, y: CGFloat(rowHeihgt-1), width: self.bounds.width - 40, height: 1))
            separator.backgroundColor = UIColor.darkGray
            btn.addSubview(separator)
            self.addSubview(btn)
        }
    }
    
    fileprivate func addCancel(){
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 20, y: self.bounds.height - CGFloat(rowHeihgt), width: self.bounds.width - 40 , height: CGFloat(rowHeihgt))
        btn.backgroundColor = UIColor.white
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.setTitle("取消", for: .normal)
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.addSubview(btn)
    }
    
    @objc func itemSelected(_ btn: UIButton){
        cancel()
        self.delegate?.itemSelected(index: btn.tag)
    }
    
    init(handeler:PickerItemSelectDelegate,title:String,items:[T],mother:UIView) {
        super.init(frame: onRect)
        self.delegate = handeler
        self.frame = offRect
        self.backgroundColor = UIColor.clear
        self.bgMask.frame = self.bounds
        self.addSubview(bgMask)
        addCancel()
        addItrms(items)
        addTitle(title: title, itemsCount: items.count)
        mother.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancel(){
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.frame = self.offRect
        }, completion: {over in
            self.removeFromSuperview()
        })
    }
    
    func show(){
        UIView.animate(withDuration: 0.5, animations: {() -> Void in
            self.frame = self.onRect
        })
    }
}
