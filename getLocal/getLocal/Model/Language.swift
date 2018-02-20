//
//  Language.swift
//  getLocal
//
//  Created by Emil Iliev on 2/21/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import Foundation

enum Language: EnumCollection {
    case eng
    case bg
}


extension Language: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .bg:
            return "Bulgarian"
        case .eng:
            return "English"
        }
    }
}
