//
//  GoogleDataManager.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol GoogleManagerDelegate {
    func didRetrieveSymptomData(symptomsData: [Symptom])
    func didRetrieveFoodData(foodsData: [Food])
    func didFailWithError(error: Error)
}

struct GoogleDataManager {
    
    var delegate: GoogleManagerDelegate?
    let db = Firestore.firestore()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func downloadSymptomsAndFoodDataFromGoogle(searchDate: String) {
        var savedSymptoms = [Symptom]()
        var saveFoods = [Food]()
        
        db.collection(K.FStore.symptomsCollectionName).whereField(K.FStore.dateField, isEqualTo: searchDate)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let symptomTitle = data[K.FStore.symptomField] as? String {
                            let newSymptom = Symptom(context: self.context)
                            newSymptom.title = symptomTitle
                            newSymptom.isChecked = false
                            savedSymptoms.append(newSymptom)
                        }
                    }
                    DispatchQueue.main.async {
                        self.delegate?.didRetrieveSymptomData(symptomsData: savedSymptoms)
                    }
                }
        }
        db.collection(K.FStore.foodCollectionName).whereField(K.FStore.dateField, isEqualTo: searchDate)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let foodTitle = data[K.FStore.foodField] as? String {
                            let newFood = Food(context: self.context)
                            newFood.title = foodTitle
                            newFood.isChecked = false
                            saveFoods.append(newFood)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.delegate?.didRetrieveFoodData(foodsData: saveFoods)
                }
        }
    }
    
}
