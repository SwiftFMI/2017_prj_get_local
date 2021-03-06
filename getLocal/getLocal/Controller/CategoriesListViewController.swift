//
//  CategoriesListViewController.swift
//  getLocal
//
//  Created by Kirilov, Hristo on 19.02.18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class CategoriesListUserController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categories : [Category] = Category.allCategories
    
    var selectedCategory : Category!
    
    @IBOutlet var categoriesTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "categories".localized
        categoriesTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category") as! CategoryTableViewCell
        
        cell.categoryLabel.text = categories[indexPath.row].plural.localized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCategory = categories[indexPath.row]
        
        performSegue(withIdentifier: "category", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "category") {
            let viewController = segue.destination as! ObjectsListViewController
            viewController.category = selectedCategory
        }
    }
}
