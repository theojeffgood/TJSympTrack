//
//  TJSymptomsBrain.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct TJSymptomsBrain{
    
    let selectedSymptoms = [Symptom].self
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func saveContext() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
//    func displaySearchResults(food: FoodData){
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        for eachFood in food.common {
//            let newFood = Food(context: context)
//            newFood.title = eachFood.tag_name
//            newFood.isChecked = false
//            //            universeOfFood[1].append(newFood)
//        }
//        TJSymptomsBrain.saveContext()
//    }
    
    static func loadSymptoms() -> ([[Symptom]]) {
        let request: NSFetchRequest<Symptom> = Symptom.fetchRequest()
        var commonSymptoms = [Symptom]()
        var selectedSymptoms = [Symptom]()
        
        do {
            let allSymptoms = try context.fetch(request)
            commonSymptoms = allSymptoms.filter( {$0.isChecked == false }).map({ return $0 })
            selectedSymptoms = allSymptoms.filter( {$0.isChecked == true }).map({ return $0 })
        } catch{
            print("Error fetching data from context \(error)")
        }
        return ([selectedSymptoms,commonSymptoms])
    }
    
    static func loadFoods() -> ([[Food]]) {
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        var commonFoods = [Food]()
        var selectedFoods = [Food]()
        
        do {
            let allFoods = try context.fetch(request)
            commonFoods = allFoods.filter( {$0.isChecked == false }).map({ return $0 })
            selectedFoods = allFoods.filter( {$0.isChecked == true }).map({ return $0 })
        } catch{
            print("Error fetching data from context \(error)")
        }
        return ([selectedFoods,commonFoods])
    }
}
