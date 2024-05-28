//
//  MenuController.swift
//  OrderApp
//
//  Created by Cesar Fernandez on 5/22/24.
//

import Foundation
import UIKit

class MenuController {
    //page 492
    enum MenuControllerError: Error, LocalizedError {
        case categoriesNotFound
        case menuItemsNotFound
        case orderRequestFailed
        case imageDataMissing
    }
    static let shared = MenuController()
    // page 527
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    let baseURL = URL(string: "http://127.0.0.1:8080")!
    
    // page 526
    var order = Order() {
        //didSet addition in pg 528
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        }
    }

    // page 491
    func fetchCategories() async throws -> [String] {
        // added body on page 494
        let categoriesURL = baseURL.appendingPathComponent("categories")
        let (data, response) = try await URLSession.shared.data(from: categoriesURL)
        // added guard on page 498
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.categoriesNotFound
        }
        
        let decoder = JSONDecoder()
        let categoriesResponse = try decoder.decode(CategoriesResponse.self, from: data)
        
        return categoriesResponse.categories
    }
    
    
    func fetchMenuItems(forCategory categoryName: String) async throws -> [MenuItem] {
        // added body on page 494
        let baseMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        let (data, response) = try await URLSession.shared.data(from: menuURL)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.menuItemsNotFound
        }
        
        let decoder = JSONDecoder()
        let menuResponse = try decoder.decode(MenuResponse.self, from: data)
        
        return menuResponse.items
    }
    
    typealias MinutesToPrepare = Int
    
    func submitOrder(forMenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let menuIdsDict = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(menuIdsDict)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.orderRequestFailed
        }
        
        let decoder = JSONDecoder()
        let orderResponse = try decoder.decode(OrderResponse.self, from: data)
        
        return orderResponse.prepTime
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.imageDataMissing
        }
        
        guard let image = UIImage(data: data) else {
            throw MenuControllerError.imageDataMissing
        }
        
        return image
    }
}
