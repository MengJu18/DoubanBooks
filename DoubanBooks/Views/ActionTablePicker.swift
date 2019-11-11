//
//  ActionTablePicker.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/11/9.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit

class ActionTablePicker: UIView {
    var delegate: UITableViewDelegate?
    var dataSource: UITableViewDataSource?
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
    
    fileprivate func addTitle(title: String, itemsCount: Int){
        let n: Int = {
            if itemsCount < 6 {
                return itemsCount
            }
            return 6
        }()
        let y = self.bounds.height - CGFloat(itemsCount * rowHeihgt + rowHeihgt + 20 + rowHeihgt + 20 )
        let lblTitle  = UILabel(frame: CGRect(x: 20, y: y, width: self.bounds.width - 40, height: CGFloat(rowHeihgt + 10)))
        lblTitle.textAlignment = .center
        lblTitle.backgroundColor = UIColor.white
        lblTitle.textColor = UIColor.black
        lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
        lblTitle.text = title
        self.addSubview(lblTitle)
    }
    
    fileprivate func addTableView(_ count: Int) {
        let n: Int = {
            if count < 6 {
                return count
            }
            return 6
        }()
        let y = self.bounds.height - CGFloat(n * rowHeihgt + rowHeihgt + 20 + rowHeihgt + 20 )
         let table = UITableView(frame: CGRect(x: 20, y: y, width: UIScreen.main.bounds.width - 40, height: CGFloat(rowHeihgt * n)))
        table.dataSource = dataSource
        table.delegate = delegate
        self.addSubview(table)
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
    
    @objc func cancel(){
        UIView.animate(withDuration: 0.4, animations: {() -> Void in
            self.frame = self.offRect
        }, completion: {over in
            self.removeFromSuperview()
        })
    }
    
     init(title: String, count: Int, dataSource:UITableViewDataSource, delegate:UITableViewDelegate){
        super.init(frame: onRect)
        self.dataSource = dataSource
        self.delegate = delegate
        self.frame = offRect
        self.backgroundColor = UIColor.clear
        self.bgMask.frame = self.bounds
        bgMask.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancel)))
        self.addSubview(bgMask)
        addCancel()
        addTitle(title: title, itemsCount: count)
        addTableView(count)
    }
    
    func show(superView: UIView) -> ActionTablePicker {
        UIView.animate(withDuration: 0.4, animations: {
            self.frame = self.onRect
            self.removeFromSuperview()
            superView.addSubview(self)
        })
            return self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
