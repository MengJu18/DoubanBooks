//
//  BooksController.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/22.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class BooksController: UITableViewController,EmptyViewDelegate {
    let bookSuge = "bookSuge"
    let bookcell = "cell"
    var category = VMCategory()
    var books: [VMBook]?
    let factory = BookFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)
    var isEmpty:Bool{
        get{
            if let data = books {
                return data.count == 0
                
            }
            return true
        }
    }
    var imgEmpty:UIImageView?
    func createEmptyView() -> UIView?{
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
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            books = try factory.getBooksOF(category: category.id)
        } catch DataError.readCollectionError(let info){
            books = [VMBook]()
            UIAlertController.showAlertAndDismiss(info, in: self,completion:{
                self.navigationController?.popViewController(animated: true)
            })
        }catch{
            books = [VMBook]()
            UIAlertController.showAlertAndDismiss(error.localizedDescription, in: self,completion:{
                self.navigationController?.popViewController(animated: true)
            })
        }
        tableView.setEmtpyTableViewDelegate(target: self)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name(rawValue: navigations), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func reload(){
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books!.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: bookcell, for: indexPath) as! BookCell
        let Book = books![indexPath.row]
        cell.lblBookName.text = Book.title
        cell.lblName.text = Book.author
        cell.lblSynopsis.text = Book.summary
//        cell.lblBookImage.image = UIImage(contentsOfFile: NSHomeDirectory().appending(imgDir).appending((category.image!)))
        Alamofire.request(Book.image!).responseImage{ response in
            if let image = response.result.value {
                cell.lblBookImage.image = image
               }
            }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: bookSuge, sender: indexPath.row)
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
     override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let (success, _) = try! factory.removeBook(book: books![indexPath.row])
            if !success {
               UIAlertController.showAlertAndDismiss("删除失败", in: self)
            }
            books = try? factory.getBooksOF(category: category.id)
             UIAlertController.showAlertAndDismiss("删除成功", in: self)
            tableView.reloadData()
        } else if editingStyle == .insert {}
        
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == bookSuge {
            let destinatons = segue.destination as! BookDateController
            if sender is Int {
                let book = self.books![sender as! Int]
                destinatons.book = book
                destinatons.category = category
               destinatons.readonly = true
               
                
            }
        }
        
    }

}
