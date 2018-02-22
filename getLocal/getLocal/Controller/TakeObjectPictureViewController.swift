//
//  TakeObjectPictureViewController.swift
//  getLocal
//
//  Created by Petar Ivanov on 2/19/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class TakeObjectPictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
    
    @IBOutlet weak var takePictureButton: UIButton!
    @IBOutlet weak var nextTakePictureButton: UIButton!
    @IBOutlet weak var imageTake: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressBar: UIView!
   
    
    var imagePicker: UIImagePickerController!
    var addObjectStep : Int = 1
    private var photoIsChanged: Bool = false
    
    
    @IBAction func goToChooseObjectCategory(_ sender: UIButton) {
//        if photoIsChanged == false {
//            showErrorAlert()
//            return
//        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Set object's photo"
        
        updateUI()
        
        changeLanguage()
        handleNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Error!", message: "You didn't change the default photo!", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Okay!", style: .default) { (action:UIAlertAction) in
        }
        
        alertController.addAction(action1)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Update User Interface
    func updateUI() {
        progressLabel.text = String(addObjectStep) + "/\(NumberConstants.numberOfSteps.rawValue)"
        
        progressBarWidthConstraint.constant = (view.frame.size.width / CGFloat(NumberConstants.numberOfSteps.rawValue)) * CGFloat(addObjectStep)
    }
    
    private func handleNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "\(Notifications.languageChanged)"), object: nil)
    }
    
    @objc private func changeLanguage() {
        takePictureButton.setTitle("take_picture_btn".localized, for: .normal)
        nextTakePictureButton.setTitle("next_take_picture".localized, for: .normal)
    }
    
    //MARK: - Take a photo
    @IBAction func takePhoto(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Finalize image capture
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)

        if let newImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageTake.image = newImg
            self.photoIsChanged = true
        } else {
            self.photoIsChanged = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let objectImage: UIImage = imageTake.image!
        let compressData = UIImageJPEGRepresentation(objectImage, 0.5)
        let compressedObjectImage = UIImage(data: compressData!)!
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if let chooseObjectCategoryVC = segue.destination as? ChooseObjectCategoryViewController {
            chooseObjectCategoryVC.objectImage = compressedObjectImage
            chooseObjectCategoryVC.addObjectStep = addObjectStep + 1
        }
    }
    
}
