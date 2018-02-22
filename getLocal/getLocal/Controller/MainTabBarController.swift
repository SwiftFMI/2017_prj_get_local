//
//  MainTabBarController.swift
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeLanguage()
        handleNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func handleNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "\(Notifications.languageChanged)"), object: nil)
    }

    @objc private func changeLanguage() {
        for controller in viewControllers! {
            let navigationTopController = (controller as! UINavigationController).viewControllers.first!
            let tabBarItemtitle: String
            switch navigationTopController {
            case is ObjectsMapViewController:
                tabBarItemtitle = "tabbar.title.map"
            case is CameraViewController:
                tabBarItemtitle = "tabbar.title.camera"
            case is NewObjectViewController:
                tabBarItemtitle = "tabbar.title.new_object"
            case is InfoViewController:
                tabBarItemtitle = "tabbar.title.info"
            case is CategoriesListUserController:
                tabBarItemtitle = "tabbar.title.objects"
            default:
                assertionFailure("No such controller")
                tabBarItemtitle = ""
            }
            
            controller.tabBarItem.title = tabBarItemtitle.localized
        }
    }
}
