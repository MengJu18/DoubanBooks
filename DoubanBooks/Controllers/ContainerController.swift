//
//  ContainerController.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/11/12.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit

class ContainerController: UIViewController,PageContainerDelegate {
   
    
    @IBOutlet weak var vIndictor1: UIView!
    @IBOutlet weak var vIndictor2: UIView!
    @IBOutlet weak var vIndictor3: UIView!
    var indicators: [UIView]!
    var controller: ChartsPageController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       controller = (children.first as! ChartsPageController)
        controller.container = self
        indicators = [vIndictor1, vIndictor2, vIndictor3]
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapToChangeChart(_ sender: UIButton) {
        let index = sender.tag
        controller.setPage(to: index)
        swicgTabButton(to: index)
    }
    
    func swicgTabButton(to index: Int) {
        for indictor in indicators! {
            if indicators.firstIndex(of: indictor) == index {
                indictor.backgroundColor = UIColor.blue
            } else {
                indictor.backgroundColor = UIColor.lightGray
            }
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
