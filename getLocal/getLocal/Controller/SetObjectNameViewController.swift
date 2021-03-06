//
//  SetObjectNameViewController.swift
//  getLocal
//
//  Created by Petar Ivanov on 2/19/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class SetObjectNameViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var objectDescriptionTextView: UITextView!
    @IBOutlet weak var objectWorkingTimeField: UITextField!
    @IBOutlet weak var setNameInstructionsLabel: UILabel!
    @IBOutlet weak var nextSetNameButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var objectNameTextField: UITextField!
    
    
    var objectImage: UIImage = UIImage()
    var objectCategory: String = ""
    var addObjectStep : Int = 0
    
    @IBAction func goToSetLocation(_ sender: UIButton) {
        if objectNameTextField.text?.isEmpty == true {
            showErrorAlert()
            return
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "set_name_title".localized
        
//        objectNameTextField.text = "Enter object's name"
//        objectNameTextField.textColor = UIColor.lightGray
        
        objectNameTextField.delegate = self
        
        updateUI()
        
        changeLanguage()
        handleNotifications()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK: - Update User Interface
    func updateUI() {
        progressLabel.text = String(addObjectStep) + "/\(NumberConstants.numberOfSteps.rawValue)"
        
        progressBarWidthConstraint.constant = (view.frame.size.width / CGFloat(NumberConstants.numberOfSteps.rawValue)) * CGFloat(addObjectStep)
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Error!", message: "You didn't enter a name for the object!", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Okay!", style: .default) { (action:UIAlertAction) in
        }
        
        alertController.addAction(action1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func handleNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "\(Notifications.languageChanged)"), object: nil)
    }
    
    @objc private func changeLanguage() {
        nextSetNameButton.setTitle("next_set_name".localized, for: .normal)
        setNameInstructionsLabel.text = "set_name_instructions".localized
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let objectName: String = objectNameTextField.text!
        let objectWorkingTime: String = objectWorkingTimeField.text!
        let objectDescription: String = objectDescriptionTextView.text!
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if let setObjectLocationVC = segue.destination as? SetObjectLocationViewController {
            setObjectLocationVC.objectImage = objectImage
            setObjectLocationVC.objectCategory = objectCategory
            setObjectLocationVC.objectTitle = objectName
            setObjectLocationVC.addObjectStep = addObjectStep + 1
            setObjectLocationVC.objectWorkTime = objectWorkingTime
            setObjectLocationVC.objectDescription = objectDescription
        }
    }
    
//    private func textViewDidBeginEditing(_ textView: UITextView) {
//        if objectNameTextField.textColor == UIColor.lightGray {
//            objectNameTextField.text = nil
//            objectNameTextField.textColor = UIColor.black
//        }
//    }
//
//    private func textViewDidEndEditing(_ textView: UITextView) {
//        if objectNameTextField.text?.isEmpty == true {
//            objectNameTextField.text = "Enter object's name"
//            objectNameTextField.textColor = UIColor.lightGray
//        }
//    }
    
    // built in method
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
        if textField == self.objectNameTextField {
            self.objectWorkingTimeField.becomeFirstResponder()
        }
        if textField == self.objectWorkingTimeField {
            self.objectDescriptionTextView.becomeFirstResponder()
        }
        if textField == self.objectDescriptionTextView {
          self.objectDescriptionTextView.resignFirstResponder()
        }
        
        return true
    }
    
}
