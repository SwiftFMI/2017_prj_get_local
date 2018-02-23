//
//  NewObjectViewController.swift
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class NewObjectViewController: UIViewController {

    
    @IBOutlet weak var startAddingObjectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "new_object_title".localized
        
        changeLanguage()
        handleNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    private func handleNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "\(Notifications.languageChanged)"), object: nil)
    }
    
    @objc private func changeLanguage() {
        startAddingObjectButton.setTitle("take_picture".localized, for: .normal)
    }
}
