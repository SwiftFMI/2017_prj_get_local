//
//  Common.swift
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import Foundation



enum SegueIDs {
  case unwindToLogin
}


enum StoryboardIDS: String {
    case loginVC = "LoginViewController"
	case mainVC = "MainTabBarController"
    case mapVC = "MapViewController"
    case objectListVC = "ObjectListViewController"
    case objectDetailsVC = "ObjectDetailsViewController"
    case profileVC
    case languageVC
//    case themeVC
    case objectsList
}


enum Notifications {
    case languageChanged
}


enum NumberConstants: Int {
    case numberOfSteps = 4
}
