//
//  Categories.swift
//  getLocal
//
//  Created by Kirilov, Hristo on 20.02.18.
//  Copyright © 2018 Petar Ivanov. All rights reserved.
//

import Foundation

enum Category :String{
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
            case .restaurant: return "Restaurants"
            case .club: return "Clubs"
            case .pharmacy: return "Pharmacies"
            case .shop: return "Shops"
            case .services: return "Services"
            case .other: return "Other"
            case .allObjects: return "All objects"
            case .favourites: return "Favourites"
            case .myObjects: return "My objects"
        }
    }
    
    static let allCategories = [favourites, allObjects, restaurant, club, pharmacy, shop, services, other, myObjects]
}
