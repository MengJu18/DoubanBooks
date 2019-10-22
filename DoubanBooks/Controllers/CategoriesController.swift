//
//  CategoriesController.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/18.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import UIKit

private let reuseIdentifier = "categoryCell"

class CategoriesController: UICollectionViewController {

    var categories: [VMCategory]?
    let factory = CategoryFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let a = VMCategory()
        a.name = "1"
        categories?.append(a)
        do {
            categories = try factory.getAllCategories()
        } catch DataError.readCollectionError(let info) {
            categories = [VMCategory]()
            UIAlertController.showAlertAndDismiss(info, in: self)
        } catch {
            categories = [VMCategory]()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(noti:)), name: Notification.Name(rawValue: notiCategory), object: nil)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func refresh(noti: Notification) {
        //刷新
        let name = noti.userInfo!["name"] as! String
        do {
            categories?.removeAll()
            categories?.append(contentsOf: try factory.getAllCategories())
            UIAlertController.showAlertAndDismiss("\(name)添加成功", in: self, completion: {
                self.navigationController?.popViewController(animated: true)
                self.collectionView.reloadData()
            })
        } catch DataError.readCollectionError(let info) {
            categories = [VMCategory]()
            UIAlertController.showAlertAndDismiss(info, in: self)
        } catch {
            categories = [VMCategory]()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categories!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoriesViewCell
        let category = categories![indexPath.item]
        // TODO: 类别名称
        cell.lblName.text = category.name!
        // TODO: 类别次数
        cell.lblCount.text = String(factory.getBooksCountOf(category: category.id)!)
        // TODO: 图库文件保存到沙盒，取文件地址
        cell.imgCover.image = UIImage(contentsOfFile: NSHomeDirectory().appending(imgDir).appending(category.image!))
        // TODO: plist读写数据
        cell.lblEditTime.text = CategoryFactory.getEditTimeFeomPlist(id: category.id)
        cell.btnDel.isHidden = true // TODO: 随普通模式和删除模式切换可见
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
