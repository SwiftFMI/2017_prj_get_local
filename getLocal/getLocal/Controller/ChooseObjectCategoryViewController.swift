//
//  ChooseObjectCategoryViewController.swift
//  getLocal
//
//  Created by Petar Ivanov on 2/19/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class ChooseObjectCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var nextChooseCategoryButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBarWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    
    var objectImage: UIImage = UIImage()
    var pickerData: [String] = [String]()
    var addObjectStep : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "choose_category_title".localized
        
        pickerData = Category.allValues.map{ $0.rawValue }
      
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
        
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
    
    private func handleNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: NSNotification.Name(rawValue: "\(Notifications.languageChanged)"), object: nil)
    }
    
    @objc private func changeLanguage() {
        nextChooseCategoryButton.setTitle("next_choose_category".localized, for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let objectCategory: String = pickerData[categoryPickerView.selectedRow(inComponent: 0)]
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        if let setObjectNameVC = segue.destination as? SetObjectNameViewController {
            setObjectNameVC.objectImage = objectImage
            setObjectNameVC.objectCategory = objectCategory
            setObjectNameVC.addObjectStep = addObjectStep + 1
        }
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The selected row
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: pickerData[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        return attributedString
    }
}
