//
//  CategoriesListViewController.swift
//  getLocal
//
//  Created by Kirilov, Hristo on 19.02.18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class CategoriesListUserController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var categories : [String] = []
    
    @IBOutlet var categoriesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
        categories = ["restaurants", "bars", "favourites", "my objects"]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category")!
        
        cell.textLabel?.text = categories[indexPath.row]
        
        return cell
    }
}
