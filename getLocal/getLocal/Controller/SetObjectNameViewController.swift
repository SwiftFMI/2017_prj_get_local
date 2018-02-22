//
//  SetObjectNameViewController.swift
//  getLocal
//
//  Created by Petar Ivanov on 2/19/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class SetObjectNameViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var objectNameTextField: UITextField!
    
    var objectImage: UIImage = UIImage()
    var objectCategory: String = ""
    
    var addObjectStep : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Set object's name"
        
        objectNameTextField.delegate = self
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let objectName: String = "Plazza Dance Sofia"
        let objectName: String = objectNameTextField.text!
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if let setObjectLocationVC = segue.destination as? SetObjectLocationViewController {
            setObjectLocationVC.objectImage = objectImage
            setObjectLocationVC.objectCategory = objectCategory
            setObjectLocationVC.objectTitle = objectName
            setObjectLocationVC.addObjectStep = addObjectStep + 1
        }
    }
    
    func updateUI() {
        progressLabel.text = String(addObjectStep) + "/\(NumberConstants.numberOfSteps.rawValue)"
        
        progressBarWidthConstraint.constant = (view.frame.size.width / CGFloat(NumberConstants.numberOfSteps.rawValue)) * CGFloat(addObjectStep)
    }
    
    // built in method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
