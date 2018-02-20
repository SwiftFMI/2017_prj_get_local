//
//  CommonExtension.swift
//  getLocal
//
//  Created by Emil Iliev on 2/20/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    public func imageFromServerURL(url: URL, completion: @escaping () -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            
            guard error == nil, let unwrappedData = data else { print(error!); return }
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                completion()
                let image = UIImage(data: unwrappedData)
                self.image = image
            })
            
        }).resume()
    }
}
