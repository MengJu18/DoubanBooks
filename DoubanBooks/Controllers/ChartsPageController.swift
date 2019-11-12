//
//  ChartsPageController.swift
//  DoubanBooks
//
//  Created by 2017yd on 2019/11/12.
//  Copyright © 2019 2017yd. All rights reserved.
//

import UIKit

class ChartsPageController: UIPageViewController, UIPageViewControllerDataSource { //继承父类， x实现协议
    var container: PageContainerDelegate? //容器Controller 作用： 滑动切换页面时约束容器Controller更新按钮下指示条
    private lazy var controllers:[UIViewController] = {
       return[getController(identifier: "chart1"), getController(identifier: "chart3"), getController(identifier: "chart2")]
    }()  //页面Controller对象集合，使用StoryboardID获取VC对象
    
    private func getController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let chartlController = controllers.first {  //设置第一个图表Controller
            setViewControllers([chartlController], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    // 滑动切换页面时， 返回当前正显示页面的前一页的VC对象
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController) else { return nil }
        container?.swicgTabButton(to: index) // 指示容器Controller更新当前显示页的指示条为蓝色
        let prevIndex = index - 1
        guard prevIndex >= 0 else {
            return controllers.last
        }
        guard prevIndex < controllers.count else {
            return nil
        }
        return controllers[prevIndex]
    }
    
    // 滑动切换页面时， 返回当前正显示页面的前一页的VC对象
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController) else { return nil }
        container?.swicgTabButton(to: index) // 指示容器Controller更新当前显示页的指示条为蓝色
        let nextIndex = index + 1
        guard nextIndex != controllers.count else {
            return controllers.first
        }
        guard nextIndex < controllers.count else {
            return nil
        }
        return controllers[nextIndex]
    }
    
    //为容器Controller提供切换页面的功能，在容器Controller中调用（点击切换按钮时）
    func setPage(to index: Int) {
        if index >= 0 && index < controllers.count {
            setViewControllers([controllers[index]], direction: .forward, animated: true, completion: nil)
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
