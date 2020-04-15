//
//  FoodManager.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import Foundation

protocol FoodManagerDelegate {
    func didUpdateFood(food: FoodData)
    func didFailWithError(error: Error)
}

struct FoodManager {

    let foodUrl = "https://trackapi.nutritionix.com/v2/search/instant?query"
    
    var delegate: FoodManagerDelegate?
    
    func fetchFoods (_ foodName: String){
        let brandedSearchParameter = "branded=false"
        let safeFoodName = foodName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(foodUrl)=\(safeFoodName)&\(brandedSearchParameter)"
        performFoodRequest(with: urlString)
    }
        
    func performFoodRequest(with urlString: String){
        // 1. Create a valid URL
        if let url = URL(string: urlString) {
            // 2. Create a url Session
            let session = URLSession(configuration: .default)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("8b2064bc", forHTTPHeaderField: "x-app-id")
            request.addValue("ee8c1590bf5c0e7b43ba1d06dff4074f", forHTTPHeaderField: "x-app-key")
        
                // 3. Give the url session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let food = self.parseJSON(foodData: safeData) {
                        
                        self.delegate?.didUpdateFood(food: food)
                    }
                }
            }
            // 4. Kickoff the task (e.g. pressing enter in the url bar)
            task.resume()
            }
        }
    
    func parseJSON(foodData: Data) -> FoodData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(FoodData.self, from: foodData)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
