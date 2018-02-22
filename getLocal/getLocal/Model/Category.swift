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
    case all
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
            case .all: return "all"
            case .favourites: return "favourites"
            case .myObjects: return "my objects"
        }
    }
    
    static let allCategories = [restaurant, club, pharmacy, shop, services, other, all, favourites, myObjects]
}
