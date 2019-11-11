//
//  BookDateController.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/11/4.
//  Copyright © 2019 2017yd. All rights reserved.
//
import Alamofire
import AlamofireImage
import UIKit

class BookDateController: UIViewController,PickerItemSelectDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource {
    
  
    @IBOutlet weak var imgCover: UIImageView!//图片
    @IBOutlet weak var lblUserName: UILabel!//作者
    @IBOutlet weak var lblPublisher: UILabel!//出版社
    @IBOutlet weak var lblPrice: UILabel!//价格
    @IBOutlet weak var lblPubdate: UILabel!//出版日期
    @IBOutlet weak var lblAuthor: UILabel!//作者简介
    @IBOutlet weak var lblBrief: UILabel!//书籍简介
    @IBOutlet weak var ButCollection: UIBarButtonItem!//收藏
    @IBOutlet weak var angTitle: UINavigationItem!//书名
    var readonly = false
    var book:VMBook?
    var category: VMCategory?
    let categories: [VMCategory]? = try? CategoryFactory.getInstance(UIApplication.shared.delegate as! AppDelegate).getAllCategories()
    
    let factory = BookFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUserName.text = "作者：\(book!.author! )"
        lblPublisher.text = "出版社：\(book!.publisher!)"
        lblPubdate.text = "出版日期：\(book!.pubdate!)"
        lblPrice.text = "价格：\(book!.price!)"
       lblAuthor.text = "\(book!.author_intro!)"
        lblBrief.text = "\(book!.summary!)"
        angTitle.title = book!.title
        // TODO: 请求网络图片
        Alamofire.request(book!.image!).responseImage{ response in
            if let image = response.result.value {
                self.imgCover.image = image
            }
        }
        var icStar = "ic_star_off"
        let exists = (try? factory.isBookExists(book: book!)) ?? false
        if exists {
            icStar = "ic_star_on"
        }
        ButCollection.image = UIImage(named: icStar)
        ButCollection.isEnabled = !readonly
    }
    

    @IBAction func completeAction(_ sender: Any) {
     dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func collectionAction(_ sender: Any) {
        let exists = (try? factory.isBookExists(book:book!)) ?? false
        if exists {
            let (success, error) = try!factory.removeBook(book: book!)
            if success{
                ButCollection.image = UIImage(named: "ic_star_off")
            }else{
                UIAlertController.showAlertAndDismiss(error!, in: self)
            }
        }else{
            if category != nil{
                book?.categoryId = category!.id
                let (success,_) = factory.add(book: book!)
                if success{
                    ButCollection.image = UIImage(named: "ic_star_on")
                }
            } else {
//                let picker = ActionViewPicker<VMCategory>(handeler: self, title: " 图书类别", items: categories!, mother: self.view)
//                picker.show()
//                let tablePicker = ActionTablePicker(title: "图书类别", count: categories!.count, dataSource: self, delegate: self).show(superView: self.view)
                  pickOfCollection = ActionCollectionPicker(title: "图书类别", count: categories!.count, dataSource: self, delegate: self, reuseld: actionCellReuseId).show(superView: self.view)
            }
        }
    }
    func itemSelected(index: Int) {
        let category = categories![index]
        book?.categoryId = category.id
        let (success,_) = factory.add(book: book!)
        if success{
            ButCollection.image = UIImage(named: "ic_star_on")
        }
    }
    
    private var tablePicker: ActionTablePicker?
     private var pickOfCollection: ActionCollectionPicker?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let c = categories![indexPath.row]
        cell.textLabel?.text = c.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    private let actionCellReuseId = "ActionCell"
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return categories!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: actionCellReuseId, for: indexPath) as! ActionCollectionCell
        let c = categories![indexPath.row]
        cell.lblTitle.text = c.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemSelected(index: indexPath.row)
        if pickOfCollection != nil {
            pickOfCollection?.cancel()
        }
    }
    
}
