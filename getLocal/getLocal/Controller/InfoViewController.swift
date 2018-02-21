//
//  InfoViewController.swift
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class InfoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        handleNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == 0, let menuRow = Menu(rawValue: indexPath.row)
        else { return }
        
        cell.textLabel?.text = "\(menuRow)"
    }
    
    private func handleNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: NSNotification.Name(rawValue: "\(Notifications.languageChanged)"), object: nil)
    }
    
    @objc private func languageChanged() {
        tableView.reloadData()
    }
}

private enum Menu: Int {
    case profile = 0
    case myObjects
    case likedObjects
    case changeLanguage
    case changeTheme
}

extension Menu: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .profile:
            return "profile".localized
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














