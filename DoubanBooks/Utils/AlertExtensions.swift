//
//  AlertExtensions.swift
//  MovieFilm
//
//  Created by 2017yd on 2019/9/28.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import UIKit

extension UIAlertController{
    static func showAlert(_ message:String, in contorller:UIViewController){
        //显示一个警告框
        let alertController = UIAlertController(title: "⚠️警告",message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        contorller.present(alertController, animated: true, completion: nil)
    }
    static func showConfirm(_ message:String, in contorller:UIViewController,confirm:((UIAlertAction)->Void)?){
        //显示一个对话框，确定按钮可以执行confirm方法
        let alertController = UIAlertController(title: "⚠️警告",message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .destructive, handler: confirm)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        contorller.present(alertController, animated: true, completion: nil)
    }
    static func showAlertAndDismiss(_ message:String, in contorller:UIViewController){
        //显示一个警告框，几秒钟后自动消失
        let alertController = UIAlertController(title: message,message: nil, preferredStyle: .alert)
        contorller.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3, execute: {()->Void in
            contorller.presentedViewController?.dismiss(animated: true, completion: nil)
        })
    }
    static func showAlertAndDismiss(_ message:String, in contorller:UIViewController,completion:(()->Void)? = nil){
        //显示一个警告框，几秒钟后自动消失,具有dismiss的回调方法
        let alertController = UIAlertController(title: message,message: nil, preferredStyle: .alert)
        contorller.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3, execute: {()->Void in
            contorller.presentedViewController?.dismiss(animated: true, completion: completion)
        })
    }
}
