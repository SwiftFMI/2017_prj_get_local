//
//  TakeObjectPictureViewController.swift
//  getLocal
//
//  Created by Petar Ivanov on 2/19/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class TakeObjectPictureViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageTake: UIImageView!
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet var progressBar: UIView!
    
    var imagePicker: UIImagePickerController!
    
    var addObjectStep : Int = 1
    
    private var photoIsChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Set object's photo"
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func updateUI() {
        progressLabel.text = String(addObjectStep) + "/\(NumberConstants.numberOfSteps.rawValue)"
        
        progressBarWidthConstraint.constant = (view.frame.size.width / CGFloat(NumberConstants.numberOfSteps.rawValue)) * CGFloat(addObjectStep)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
