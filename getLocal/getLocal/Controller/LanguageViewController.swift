//
//  LanguageViewController.swift
//  getLocal
//
//  Created by Emil Iliev on 2/20/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class LanguageViewController: UITableViewController {

    private(set) var languages: [LanguageEnum] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        languages = LanguageEnum.allValues
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// MARK: - UITableViewDelegate & DataSource

extension LanguageViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(languages[indexPath.item])"
        
        if languages[indexPath.item] == Language.shared.currentLanguage {
            cell?.accessoryType = .checkmark
        }
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard Language.shared.currentLanguage != languages[indexPath.row] else { return }
        
        let language = languages[indexPath.row]
        self.presentAlert(for: language)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    private func presentAlert(for language: LanguageEnum) {
        let alertController = UIAlertController(title: "Chaging language", message: "Are you sure you wnat to change the language?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            self.changeLanguage(to: language)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func changeLanguage(to language: LanguageEnum) {
        Language.shared.change(language: language)
        navigationController?.popViewController(animated: true)
    }
}











