//
//  LoadMealDataFromGoogle.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 6/2/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol LoadMealDataFromGoogleDelegate {
    func didRetrieveMealData(symptomsTitles: [String], foodsTitles: [String], mealDateTitle: String)
    func didFailWithError(error: Error)
}

struct LoadMealDataFromGoogle {
    
    var delegate: LoadMealDataFromGoogleDelegate?
    let db = Firestore.firestore()
    
    func loadMealsData(searchDate: String) {
        let mealsCollectionReference = db.collection("meals")
        let mealsLoadingQuery = mealsCollectionReference.whereField(K.FStore.dateField, isEqualTo: searchDate)
        
        mealsLoadingQuery.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    guard let symptomsTitles = data["symptoms"] as? Array<String> else {return}
                    guard let foodsTitles = data["foods"] as? Array<String> else {return}
                    guard let mealDateTitle = data["date"] as? String else {return}
                    
                    self.delegate?.didRetrieveMealData(symptomsTitles: symptomsTitles, foodsTitles: foodsTitles, mealDateTitle: mealDateTitle)
                }
            }
        }
    }
}

