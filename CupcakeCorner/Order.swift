//
//  Order.swift
//  CupcakeCorner
//
//  Created by Kamol Madaminov on 02/04/25.
//

import Foundation

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _city = "city"
        case _zipCode = "zipCode"
    }
    
    static let types = ["Vanilla", "Chocolate", "Strawberry", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet{
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zipCode = ""
    
    var hasValidAddress: Bool{
        if name.count > 2 && streetAddress.count > 2 && city.count > 2 && zipCode.count == 5{
            return true
        }
        return false
    }
    
    var cost: Decimal{
        // $2 per cake
        var cost = Decimal(quantity * 2)
        
        // complicated cakes cost more(by order in array)
        cost += Decimal(type) / 2
        
        // $1/cake for extra frosting
        if extraFrosting{
            cost += Decimal(quantity)
        }
        
        // $0.5/cake for sprinkles
        if addSprinkles{
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
}
