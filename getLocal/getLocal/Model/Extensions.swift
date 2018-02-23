//
//  Extensions.swift
//  getLocal
//
//  Created by Latchezar Mladenov on 2/22/18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import UIKit
import FirebaseStorage

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ objectId: String, _ imageUrl: String, _ loader: UIActivityIndicatorView?) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: objectId + imageUrl as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let storageRef = Storage.storage().reference()
        storageRef.child(objectId).child(imageUrl).getData(maxSize: 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.image = UIImage(data: data!)
                if let loader = loader {
                    loader.stopAnimating()
                }
                imageCache.setObject(self.image!, forKey: objectId + imageUrl as NSString)
            }
        }
    }
    
}
