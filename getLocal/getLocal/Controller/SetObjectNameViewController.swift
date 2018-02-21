//
//  SetObjectNameViewController.swift
//  getLocal
//
//  Created by Petar Ivanov on 2/19/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class SetObjectNameViewController: UIViewController {
    
    @IBOutlet weak var objectNameTextField: UITextField!
    
    var objectImageUrl: String = ""
    var objectCategory: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let objectName: String = "Plazza Dance Sofia"
        let objectName: String = objectNameTextField.text!
        
        if let setObjectLocationVC = segue.destination as? SetObjectLocationViewController {
            setObjectLocationVC.objectImageUrl = objectImageUrl
            setObjectLocationVC.objectCategory = objectCategory
            setObjectLocationVC.objectTitle = objectName
        }
    }
    
    // built in method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
