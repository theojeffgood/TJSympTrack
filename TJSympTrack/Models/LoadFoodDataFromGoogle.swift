//
//  LoadFoodDataFromGoogle.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 6/2/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol LoadFoodDataFromGoogleDelegate {
    func didRetrieveFoodData(foodsData: [String: Int])
    func didFailWithError(error: Error)
}

struct LoadFoodDataFromGoogle {
    
    var delegate: LoadFoodDataFromGoogleDelegate?
    let db = Firestore.firestore()
    
    func loadPreExistingFoods(forSymptoms preExistingSymptoms: String) {
      var preExistingFoods: [String: Int] = [:]
        let foodsCollectionReference = db.collection("users").document("51XvMBaVYmTNKNzuukJ7").collection("symptoms").document(preExistingSymptoms).collection("foods")
        let query = foodsCollectionReference.order(by: "count", descending: true).limit(to: 4)
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let foodName = data["name"] as? String else {return}
                    guard let foodCount = data["count"] as? Int else {return}
                    preExistingFoods[foodName] = foodCount
                }
            }
            self.delegate?.didRetrieveFoodData(foodsData: preExistingFoods)
        }
    }
}

