//
//  AddCategoriesController.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/10/19.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import UIKit

let imgDir = "/Documents/"
let notiCategory = "AddCategoriesController.notiCategory"
class AddCategoriesController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblName: UITextField!
    var selectedImage: UIImage?
    let factory = CategoryFactory.getInstance(UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func saveCategory() {
        // TODO: 1.检查数据的完整性
        let name = lblName.text
        let category = VMCategory()
        category.name = name
        category.image = category.id.uuidString+".jpg"
        let (success, info) = factory.add(category: category)
        if name == nil || name!.count == 0 {
            UIAlertController.showAlertAndDismiss("类别名称不能为空", in: self)
            return
        }
        if selectedImage == nil {
            UIAlertController.showAlertAndDismiss("请选择图片", in: self)
            return
        }
        if !success {
            UIAlertController.showAlertAndDismiss(info!, in: self)
            return
        }
        saveImage(image: selectedImage!, fileName: category.image!)
        // TODO: 2.添加类别编辑时间plist
        CategoryFactory.updateEditTime(id: category.id)
        // TODO: 3.使用Notification通知列表更新
        NotificationCenter.default.post(name: Notification.Name(rawValue: notiCategory), object: nil, userInfo: ["name": category.name!])
    }
    @IBAction func pickFromPhotoLibrary(_ sender: Any) {
        let imgController = UIImagePickerController()
        imgController.sourceType = .photoLibrary
        imgController.delegate = self
        present(imgController, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImage = image
        imgCover.image = image
        dismiss(animated: true, completion: nil)
    }
    //保存图片
    func saveImage(image: UIImage, fileName: String){
        if let imageData = image.jpegData(compressionQuality: 1) as NSData? {
            let path = NSHomeDirectory().appending(imgDir).appending(fileName)
            imageData.write(toFile: path, atomically: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
