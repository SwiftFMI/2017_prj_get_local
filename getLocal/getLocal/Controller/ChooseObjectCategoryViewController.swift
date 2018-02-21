//
//  ChooseObjectCategoryViewController.swift
//  getLocal
//
//  Created by Petar Ivanov on 2/19/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class ChooseObjectCategoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var categoryPickerView: UIPickerView!
    
    var objectImageUrl: String = ""
    
    var pickerData: [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerData = ["restaurant", "club", "pharmacy", "shop", "services", "other"]
        
        // Connect data
        self.categoryPickerView.delegate = self
        self.categoryPickerView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let objectCategory: String = "bars"
        let objectCategory: String = pickerData[categoryPickerView.selectedRow(inComponent: 0)]
        
        if let setObjectNameVC = segue.destination as? SetObjectNameViewController {
            setObjectNameVC.objectImageUrl = objectImageUrl
            setObjectNameVC.objectCategory = objectCategory
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
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}
