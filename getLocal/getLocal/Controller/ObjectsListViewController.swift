//
//  ObjectsListViewController.swift
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ObjectsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var tableViewObjects: UITableView!
    
    var user: User!
    var objects = [Object]()
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    var category : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        ref = Database.database().reference().child("objects")
        
        ref.queryOrdered(byChild: "category").queryEqual(toValue: category).observe(.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.objects.removeAll()
                
                for objectSnapshot in snapshot.children.allObjects as![DataSnapshot] {
                    let object = Object(snapshot: objectSnapshot)
                    self.objects.append(object)
                }
                self.tableViewObjects.reloadData()
            }
        })
        
        categoryLabel.text = category
    }
    
    // MARK: - List Objects Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectCell") as! ObjectTableViewCell
        
        let object = objects[indexPath.row]
        
        cell.titleCell.text = object.title
        
        return cell
    }
	
}

