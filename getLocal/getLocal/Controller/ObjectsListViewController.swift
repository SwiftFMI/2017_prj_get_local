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
    @IBOutlet var objectsTable: UITableView!
    
    var user: User!
    var objects = [Object]()
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    var category : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        //startObservingDatabase()
        // Do any additional setup after loading the view.
        
        objectsTable.dataSource = self
        objectsTable.delegate = self
        categoryLabel.text = category
    }
	
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectCell") as! ObjectTableViewCell
        
        let object = objects[indexPath.row]
        
        return cell
    }
	
}

