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
import RealmSwift

struct TJSymptomsBrain{
   
   static let realm = try! Realm()
   
   static var foods: Results<Food>?
   static var symptoms: Results<Symptom>?
   
//   let selectedSymptoms = [Symptom].self
   
   static func saveFoods(food: Food) {
      do {
         try realm.write {
            realm.add(food)
         }
      } catch {
         print("Error saving food \(error)")
      }
   }
   
   static func saveSymptoms(symptom: Symptom) {
      do {
         try realm.write {
            realm.add(symptom)
         }
      } catch {
         print("Error saving symptom \(error)")
      }
   }
   
   static func deleteFoods(food: Food) {
      do {
         try realm.write {
            realm.delete(food)
         }
      } catch {
         print("Error deleting food \(error)")
      }
   }
   
   static func deleteSymptoms(symptom: Symptom) {
      do {
         try realm.write {
            realm.delete(symptom)
         }
      } catch {
         print("Error deleting symptom \(error)")
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
   
//   static func loadSymptoms() -> ([[Symptom]]) {
//      let request: NSFetchRequest<Symptom> = Symptom.fetchRequest()
//      var commonSymptoms = [Symptom]()
//      var selectedSymptoms = [Symptom]()
//
//      do {
//         let allSymptoms = try context.fetch(request)
//         commonSymptoms = allSymptoms.filter( {$0.isChecked == false }).map({ return $0 })
//         selectedSymptoms = allSymptoms.filter( {$0.isChecked == true }).map({ return $0 })
//      } catch {
//         print("Error fetching data from context \(error)")
//      }
//      return ([selectedSymptoms,commonSymptoms])
//   }
   
   static func loadFoods() -> ([Results<Food>?]) {
//      var commonFoods: Results<Food>?
//      var selectedFoods: Results<Food>?
      
      foods = realm.objects(Food.self)
      let commonFoods = foods?.filter("isChecked == %@", false)
      let selectedFoods = foods?.filter("isChecked == %@", true)
      
      return ([commonFoods,selectedFoods])
   }
   
//   static func loadFoods() -> ([[Food]]) {
//      let request: NSFetchRequest<Food> = Food.fetchRequest()
//      var commonFoods = [Food]()
//      var selectedFoods = [Food]()
//
//      do {
//         let allFoods = try context.fetch(request)
//         commonFoods = allFoods.filter( {$0.isChecked == false }).map({ return $0 })
//         selectedFoods = allFoods.filter( {$0.isChecked == true }).map({ return $0 })
//      } catch{
//         print("Error fetching data from context \(error)")
//      }
//      return ([selectedFoods,commonFoods])
//   }
   
   static func loadSymptoms() -> ([Results<Symptom>?]) {
      var commonSymptoms: Results<Symptom>?
      var selectedSymptoms: Results<Symptom>?
      
      symptoms = realm.objects(Symptom.self)
      commonSymptoms = symptoms?.filter("isChecked == %@", false)
      selectedSymptoms = symptoms?.filter("isChecked == %@", true)
      
      return ([commonSymptoms,selectedSymptoms])
   }
}
