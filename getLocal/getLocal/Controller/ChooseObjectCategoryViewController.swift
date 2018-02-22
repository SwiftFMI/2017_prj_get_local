//
//  ChooseObjectCategoryViewController.swift
//  getLocal
//
//  Created by Petar Ivanov on 2/19/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class ChooseObjectCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    var objectImage: UIImage = UIImage()
    
    var pickerData: [String] = [String]()
    
    var addObjectStep : Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Set object's category"
        
        pickerData = Category.allValues.map{ $0.rawValue }
      
        // Connect data
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        
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
//        let objectCategory: String = "bars"
        let objectCategory: String = pickerData[categoryPickerView.selectedRow(inComponent: 0)]
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if let setObjectNameVC = segue.destination as? SetObjectNameViewController {
            setObjectNameVC.objectImage = objectImage
            setObjectNameVC.objectCategory = objectCategory
        }
    }
    
    func updateUI() {
        progressBar.frame.size.width = (view.frame.size.width / 2) * CGFloat(addObjectStep)
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerData[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerData[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        return attributedString
    }
}
