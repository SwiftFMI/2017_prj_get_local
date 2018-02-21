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
    
    var objectsRef: DatabaseReference!
    var userRef: DatabaseReference!
    
    private var databaseHandle: DatabaseHandle!
    
    var category : Category!
    
    var selectedObject : Object!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser
        
        objectsRef = Database.database().reference().child("objects")
        userRef = Database.database().reference().child("users").child(user.uid)
        
        queryDb()

        categoryLabel.text = category.plural
    }
    
    private func queryDb() {
        switch category {
            case .all: queryDb(query: objectsRef.queryOrdered(byChild: "title"))
            case .favourites: queryFavourites()
            case .myObjects: queryDb(query: objectsRef.queryOrdered(byChild: "createdBy").queryEqual(toValue: user.uid))
            default: queryDb(query: objectsRef.queryOrdered(byChild: "category").queryEqual(toValue: category.rawValue))
        }
    }
    
    // MARK: - Backend communication
    private func queryDb(query: DatabaseQuery) {
        query.observe(.value, with: { (snapshot) in
            if snapshot.hasChildren() {
                var newObjects = [Object]()
                
                for objectSnapshot in snapshot.children.allObjects as![DataSnapshot] {
                    let object = Object(snapshot: objectSnapshot)
                    newObjects.append(object)
                }
                self.objects = newObjects
                self.tableViewObjects.reloadData()
            }
        })
    }
    
    private func queryFavourites() {
        userRef.child("favourites").observe(.value, with: { (snapshot) in
            let favourites = (snapshot.children.allObjects as![DataSnapshot]).map({$0.key})
            self.queryFavouriteObjects(favourites: favourites)
        })
    }
    
    private func queryFavouriteObjects(favourites: [String]) {
        self.objects.removeAll()
        self.tableViewObjects.reloadData()
        
        for favourite in favourites {
            objectsRef.queryOrdered(byChild: "uid").queryEqual(toValue: favourite).observe(.value, with: { (snapshot) in
                if snapshot.childrenCount > 0 {
                    for objectSnapshot in snapshot.children.allObjects as![DataSnapshot] {
                        let object = Object(snapshot: objectSnapshot)
                        self.objects.append(object)
                    }
                    self.tableViewObjects.reloadData()
                }
            })
        }
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedObject = objects[indexPath.row]
        
        performSegue(withIdentifier: "object", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "object") {
            let viewController = segue.destination as! ObjectDetailsViewController
            viewController.object = selectedObject
        }
    }
	
}

