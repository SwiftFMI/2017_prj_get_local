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

class ObjectsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet var tableViewObjects: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var user: User!
    var objects = [Object]()
    
    var filteredObjects = [Object]()
    var searchWord = ""
    
    var objectsRef: DatabaseReference!
    var userRef: DatabaseReference!
    
    private var databaseHandle: DatabaseHandle!
    
    var category : Category!
    
    var selectedObject : Object!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
//        searchBar.searchResultsUpdater = self
//        searchBar.dimsBackgroundDuringPresentation = false
        
        self.title = category.plural
        
        user = Auth.auth().currentUser
        objectsRef = Database.database().reference().child("objects")
        userRef = Database.database().reference().child("users").child(user.uid)
        
        queryDb()
    }
    
    private func queryDb() {
        switch category {
            case .allObjects: queryDb(query: objectsRef.queryOrdered(byChild: "title"))
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
                self.filterObjects()
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
        
        for favourite in favourites {
            objectsRef.child(favourite).observe(.value, with: { (snapshot) in
                if snapshot.hasChildren() {
                    let object = Object(snapshot: snapshot)
                    self.objects.append(object)
                    self.filterObjects()
                }
            })
        }
    }
    
    // MARK: - List Objects Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectCell") as! ObjectTableViewCell
        
        let object = filteredObjects[indexPath.row]
        
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
    
    // MARK: - Search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWord = searchText.lowercased()
        
        filterObjects()
    }
    
    private func filterObjects() {
        if searchWord == "" {
            filteredObjects = objects
        } else {
            filteredObjects = objects.filter { $0.title!.lowercased().contains(searchWord) }
        }
        
        self.tableViewObjects.reloadData()
    }
    
    // Mark: - Keyboard
    
    var keyboardEnabled = false
    @IBOutlet var tabGesture: UITapGestureRecognizer!
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillAppear() {
        tabGesture.cancelsTouchesInView = true
        keyboardEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func tapToHideKeyboard(_ sender: UITapGestureRecognizer) {
        if keyboardEnabled {
            self.searchBar.resignFirstResponder()
            keyboardEnabled = false
        }  else if tabGesture.cancelsTouchesInView {
            tabGesture.cancelsTouchesInView = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
}

