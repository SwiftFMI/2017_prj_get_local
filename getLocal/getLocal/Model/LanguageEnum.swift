//
//  Language.swift
//  getLocal
//
//  Created by Emil Iliev on 2/21/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import Foundation

enum LanguageEnum: EnumCollection {
    case eng
    case bg

    var code: String {
        switch self {
        case .eng:
            return "en"
        case .bg:
            return "bg"
        }
    }
}


extension LanguageEnum: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .bg:
            return "Bulgarian"
        case .eng:
            return "English"
        }
    }
    
    static func createLanguage(from text: String) -> LanguageEnum? {
        switch text {
        case "Bulgarian":
            return .bg
        case "English":
            return .eng
        default:
            return .eng
        }
    }
    
}

class Language {
    
    private static let kCurrent_language = "current_language"
    static let shared = Language()
    var currentLanguage: LanguageEnum = .eng

    private init() {
        loadLanguage()
    }
    
    func change(language: LanguageEnum) {
        currentLanguage = language
        saveLanguage()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "\(Notifications.languageChanged)"), object: nil)
        print("wtf, language changed!")
    }

    private func saveLanguage() {
        UserDefaults.standard.set("\(currentLanguage)", forKey: Language.kCurrent_language)
        UserDefaults.standard.synchronize()
    }

    private func loadLanguage() {
        guard let lang = UserDefaults.standard.value(forKey: Language.kCurrent_language) as? String
        else { return }
        
        if let createdLanguage = LanguageEnum.createLanguage(from: lang) {
            currentLanguage = createdLanguage
        }
    }
}

