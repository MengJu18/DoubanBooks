//
//  CategoriesController.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/18.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import UIKit

private let reuseIdentifier = "categoryCell"

class CategoriesController: UICollectionViewController ,EmptyViewDelegate{
    var isEmpty: Bool{
        get{
            if let data = categories {
                return data.count == 0
                
            }
            return true
        }
    }
     var imgEmpty:UIImageView?
    func createEmptyView() -> UIView? {
        if let empty = imgEmpty {
            return empty
        }
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let barHeight = navigationController?.navigationBar.frame.height
        let  img = UIImageView(frame: CGRect(x: (w-139)/2, y: (h-128)/2-(barHeight ?? 0), width: 139, height: 128))
        img.image = UIImage(named:"no_data")
        img.contentMode = .scaleAspectFit
        self.imgEmpty = img
        return img
        
    }
    

    var categories: [VMCategory]?
    let factory = CategoryFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)
    let BooksSegue = "booksSegue"
    
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
        let lpTap = UILongPressGestureRecognizer(target: self, action: #selector(longPressSwitch(_:)))
        collectionView.addGestureRecognizer(lpTap)
        let  tap = UITapGestureRecognizer(target: self, action:#selector(tapToStopShakingOrBooksSegue(_:)))
        collectionView.addGestureRecognizer(tap)
        collectionView.setEmtpyCollectionViewDelegate(target: self)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    var longPressed = false{
        didSet{
            if oldValue != longPressed{
                collectionView.reloadData()
            }
        }
    }
    var point: CGPoint?
    //长按
    
    @objc func longPressSwitch(_ lpTap:UILongPressGestureRecognizer){
        //如果长按（在item上）就进入删除模式
        //判断点是否在item上
        point = lpTap.location(in: collectionView)
        
        if let p = point, let _ = collectionView.indexPathForItem(at: p){
            longPressed = true
        }
    }
    @objc func tapToStopShakingOrBooksSegue( _ tap:UITapGestureRecognizer){
        //1.如果删除模式，停止删除模式
        //2.点击item的时候执行Books场景过渡
        point = tap.location(in: collectionView)
        if let p = point,collectionView.indexPathForItem(at: p) == nil {
            longPressed = false
        }
        if let p = point,let index = collectionView .indexPathForItem(at: p){
            if !longPressed{
                performSegue(withIdentifier: BooksSegue, sender: index.item)
            }
        }
    }
    @objc func deleteCategory(){
        UIAlertController.showConfirm("是否删除", in: self, confirm: {_ in
            let index = self.collectionView.indexPathForItem(at: self.point!)
            let category = self.categories![index!.item]
//            let (sueeccrr, error) =  self.factory.removeCategory(category: category)
            self.factory.removeCategory(category: category)
//            if !sueeccrr{
//                UIAlertController.showAlertAndDismiss(error!, in: self)
//            } else {
                self.categories?.remove(at: index!.item)
//            }
            let fileManager = FileManager.default
            do{
                try fileManager.removeItem(atPath: NSHomeDirectory().appending(imgDir).appending(category.image!))
            }catch{
                UIAlertController.showAlertAndDismiss("删除失败", in: self)
            }
            self.longPressed = false
            self.collectionView.reloadData()
        })
        
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
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == BooksSegue {
            let destinatons = segue.destination as! BooksController
            if sender is Int {
                let categories = self.categories![sender as! Int]
                destinatons.category = categories
            }
    }
    }

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
        
        
     
        
        if longPressed {
            let pos = collectionView.indexPathForItem(at: point!)?.item
            if pos == indexPath.item{
                cell.btnDel.isHidden = false
                let anim = CABasicAnimation(keyPath: "transform.rotation")
                anim.toValue = -Double.pi / 32
                 anim.fromValue = Double.pi / 32
                anim.duration = 0.2
                anim.repeatCount = MAXFLOAT
                anim.autoreverses = true
                cell.layer.add(anim, forKey: "SpringboardShake")
            }
            //TODO 删除模式下抖动，非删除模式下取消抖动
            cell.btnDel.addTarget(self, action: #selector(deleteCategory), for: .touchUpInside)
        }else{
            
            cell.btnDel.isHidden = true
            cell.layer.removeAllAnimations()
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(getoFindTab(_:)))
        cell.imgInfo.tag = indexPath.item
        cell.imgInfo.addGestureRecognizer(tapRecognizer)
        cell.imgInfo.isUserInteractionEnabled = true
        //cell.imgDown添加手势识别，传递正确的类别（indexPath.item）把索引用tap,tag
        
        return cell
    }
    
    
    @objc func getoFindTab(_ tap: UITapGestureRecognizer){
        if let index = tap.view?.tag {
            let findController = tabBarController?.viewControllers![1] as! FindController
            findController.category = categories![index]
            findController.kw = categories![index].name!
            findController.loadBooks(kw: categories![index].name!)
            tabBarController?.selectedIndex = 1
            tabBarController?.selectedViewController?.tabBarItem.badgeValue = categories![index].name
        }
        
        
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
