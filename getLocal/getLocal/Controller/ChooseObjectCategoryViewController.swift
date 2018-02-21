//
//  ChooseObjectCategoryViewController.swift
//  getLocal
//
//  Created by Petar Ivanov on 2/19/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class ChooseObjectCategoryViewController: UIViewController {
    
    var objectImageUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let objectCategory: String = "bars"
        
        if let setObjectNameVC = segue.destination as? SetObjectNameViewController {
            setObjectNameVC.objectImageUrl = objectImageUrl
            setObjectNameVC.objectCategory = objectCategory
        }
    }
}
