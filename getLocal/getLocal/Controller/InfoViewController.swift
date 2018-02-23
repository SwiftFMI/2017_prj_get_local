//
//  InfoViewController.swift
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit
import FirebaseAuth

class InfoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        handleNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0, let user = Auth.auth().currentUser {
            cell.imageView?.imageFromServerURL(url: user.photoURL!){ [weak self] in
                print("Avatar downloaded")
            }
            cell.textLabel?.text = user.displayName
        } else if indexPath.section == 1 {
            let menuRow = Menu(rawValue: indexPath.row)
            cell.textLabel?.text = menuRow?.description ?? ""
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        return 40
    }
    
    private func handleNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name(rawValue: "\(Notifications.languageChanged)"), object: nil)
    }
    
    @objc private func languageChanged() {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1, let menuRow = Menu(rawValue: indexPath.row) else { return }
        
        if menuRow == .myObjects  || menuRow  == .likedObjects {
            let storyboard = UIStoryboard(name: "ObjectList", bundle: nil)
            guard let objectsListVC = storyboard.instantiateViewController(withIdentifier: "\(StoryboardIDS.objectsList)") as? ObjectsListViewController else { return }
            
            let category = menuRow == .myObjects ? Category.myObjects : Category.favourites
            objectsListVC.category = category
            navigationController?.pushViewController(objectsListVC, animated: true)
        }
    }
}

private enum Menu: Int {
    case myObjects
    case likedObjects
    case changeLanguage
    case changeTheme
}

extension Menu: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .myObjects:
            return "my_objects".localized
        case .likedObjects:
            return "liked_objects".localized
        case .changeLanguage:
            return "change_language".localized
        case .changeTheme:
            return "change_theme".localized
        }
    }
}














