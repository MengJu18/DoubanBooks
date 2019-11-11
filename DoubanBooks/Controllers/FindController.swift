//
//  FindController.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/25.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
private let reuseIdentifier = "bookItemCell"
private let booksSgues = "booksSgues"
class FindController: UICollectionViewController,EmptyViewDelegate,UISearchBarDelegate{
    var category:VMCategory?
    var books:[VMBook]?
    var isLoading = false
    var currentPage = 0
    var kw = ""
    var star = ""
    var point: CGPoint?
   let factory = BookFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setEmtpyCollectionViewDelegate(target: self)
        let  tap = UITapGestureRecognizer(target: self, action:#selector(tapToStopShakingOrBooksSegue(_:)))
        collectionView.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: navigations), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func reload(){
        collectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == booksSgues {
            let destinatons = segue.destination as! BookDateController
            if sender is Int {
                let book = self.books![sender as! Int]
                destinatons.book = book
                destinatons.category = category
            }
        }
    }
    var isEmpty: Bool {
        get {
            if let data = books{
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
   
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind:UICollectionView.elementKindSectionHeader, withReuseIdentifier: "serachHeader", for: indexPath)  as! SearchHeader
        header.searchBar.delegate = self
        return header
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let kw = searchBar.text{
            tabBarController?.viewControllers![1].tabBarItem.badgeValue = kw
        }
        isLoading = false
        currentPage = 0
        category = nil
        kw = searchBar.text!
        books?.removeAll()
        loadBooks(kw: searchBar.text!)
    }
    @objc func tapToStopShakingOrBooksSegue( _ tap:UITapGestureRecognizer){
        //1.如果删除模式，停止删除模式
        //2.点击item的时候执行Books场景过渡
        point = tap.location(in: collectionView)
        if let p = point,let index = collectionView .indexPathForItem(at: p){
            performSegue(withIdentifier: booksSgues, sender: index.item)
        }
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return books?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FindViewCell
        let book = books![indexPath.item]
        cell.lblName.text = book.title
        cell.lblUserName.text = book.author
        Alamofire.request(book.image!).responseImage{response in
            if let imag = response.result.value{
                cell.imgCover.image = imag
            }
        }
        star = "star_off"
        if (try?factory.isBookExists(book: book)) ?? false {
            star = "star_on"
        }
       cell.imgCollection.image = UIImage(named: star)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(gotoFindTab(_:)))
//        cell.imgCollection.isUserInteractionEnabled = true
//        cell.imgCollection.addGestureRecognizer(tap)
//        cell.imgCollection.tag = indexPath.item
        
        
        
        cell.imgCollection.image = UIImage(named: "star_off")
        if(try? factory.isBookExists(book: book)) ?? false{
           cell.imgCollection.image = UIImage(named: "star_on")
        }
        
        if !isLoading && indexPath.item == (books?.count)!-1{
            isLoading = true
            currentPage += 1
            loadBooks(kw: kw)
        }
        
        return cell
    }

    func loadBooks(kw:String){
        Alamofire.request(BooksJson.getSearchUrl(keyword: kw, page: currentPage))
            .validate(statusCode:200..<300)
            .validate(contentType:["application/json"])
            .responseJSON{ response in
               switch response.result{
                case .success:
                    if let json = response.result.value{
                        let books = BookConverter.getBooks(json: json)
                        if books == nil || books?.count == 0 {
                            self.isLoading = true
                        }else{
                            if self.books == nil{
                                self.books = books
                            }else{
                                self.books! += books!
                            }
                            self.collectionView.reloadData()
                            self.isLoading = false
                        }
                    }else{
                        self.isEditing = true
                }
               case let .failure(error):
                UIAlertController.showAlert("网络错误：\(error.localizedDescription)",in:self)
                self.isLoading = true
                }
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
