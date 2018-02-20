//
//  Common.swift
//  getLocal
//
//  Created by Emil Iliev on 1/14/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import Foundation

var language: Language = .eng

enum SegueIDs {
  
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
}

enum Language {
    case eng
    case bg
}
