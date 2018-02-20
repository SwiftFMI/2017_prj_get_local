//
//  LanguageViewController.swift
//  getLocal
//
//  Created by Emil Iliev on 2/20/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit

class LanguageViewController: UITableViewController {

    private(set) var languages: [Language] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        languages = Language.allValues
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
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(languages[indexPath.item])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
