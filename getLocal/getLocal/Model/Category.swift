//
//  Categories.swift
//  getLocal
//
//  Created by Kirilov, Hristo on 20.02.18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import Foundation

enum Category: String {
    case restaurant = "restaurant"
    case club = "club"
    case pharmacy = "pharmacy"
    case shop = "shop"
    case services = "service"
    case other = "other"
    case allObjects
    case favourites
    case myObjects
    
    var plural: String {
        switch self {
            case .restaurant: return "restaurants"
            case .club: return "clubs"
            case .pharmacy: return "pharmacies"
            case .shop: return "shops"
            case .services: return "services"
            case .other: return "other"
            case .allObjects: return "all objects"
            case .favourites: return "liked_objects"
            case .myObjects: return "my_objects"
        }
    }
    
    static let allCategories = [favourites, allObjects, restaurant, club, pharmacy, shop, services, other, myObjects]
}

extension Category: EnumCollection {
    
}
