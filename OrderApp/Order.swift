//
//  Order.swift
//  OrderApp
//
//  Created by Cesar Fernandez on 5/22/24.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
