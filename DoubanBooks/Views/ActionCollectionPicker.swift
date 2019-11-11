//
//  ActionCollectionCell.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/11/9.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit

class ActionCollectionCell: UICollectionViewCell {
    
    var lblTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lblTitle = UILabel()
        lblTitle.font = UIFont.systemFont(ofSize:13)
        lblTitle.textAlignment = .center
        lblTitle.textColor = UIColor.black
        self.addSubview(lblTitle)
        self.backgroundColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblTitle.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 60)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    class ActionCollectionPicker: UIView {
    var delegate: UICollectionViewDelegate?
    var dataSource: UICollectionViewDataSource?
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

        fileprivate func getRows(count: Int) -> Int {
            var n = 1
            if count < 3 {
                return count
            } else {
                n = 3
            }
            return n
        }
        
        fileprivate func addTitle(title: String, itemsCount: Int){
            let n: Int = {
                if itemsCount < 3 {
                    return itemsCount
                }
                return 3
            }()
            let y = self.bounds.height - CGFloat(n * rowHeihgt + rowHeihgt + 20 + rowHeihgt + 50 + 2 )
            let lblTitle  = UILabel(frame: CGRect(x: 20, y: y, width: self.bounds.width - 40, height: CGFloat(rowHeihgt + 10)))
            lblTitle.textAlignment = .center
            lblTitle.backgroundColor = UIColor.white
            lblTitle.textColor = UIColor.black
            lblTitle.font = UIFont.boldSystemFont(ofSize: 20)
            lblTitle.text = title
            self.addSubview(lblTitle)
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
        
        init(title: String, count: Int, dataSource:UICollectionViewDataSource, delegate:UICollectionViewDelegate,reuseld: String){
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
           addCollectionView(count, reuseld: reuseld)
        }
        
        func show(superView: UIView) -> ActionCollectionPicker {
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

    
    fileprivate func addCollectionView(_ count: Int, reuseld: String) {
        let n = getRows(count: count)
        let y = self.bounds.height - CGFloat(3 * (rowHeihgt + 10) + rowHeihgt + 20 + 20)
        let layout =  UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: CGFloat((UIScreen.main.bounds.width - 80)/3), height: CGFloat(rowHeihgt))
        layout.minimumInteritemSpacing = CGFloat(10)
        layout.minimumLineSpacing = CGFloat(10)
        let table = UICollectionView(frame: CGRect(x: 20, y: y, width: UIScreen.main.bounds.width - 40,height: CGFloat(3 * (rowHeihgt + 10) + 20)), collectionViewLayout: layout)
        table.dataSource = dataSource
        table.delegate = delegate
        table.register(ActionCollectionCell.self,forCellWithReuseIdentifier: reuseld)
        table.backgroundColor = UIColor.groupTableViewBackground
        table.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.addSubview(table)
    }
}
