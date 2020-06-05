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
    func didRetrieveMealData(symptomsTitles: [String], foodsTitles: [String], mealDateTitle: String)
    func didRetrieveFoodData(foodsData: [String:Int])
    func didFailWithError(error: Error)
}

struct GoogleDataManager {
    
    var delegate: GoogleManagerDelegate?
    let db = Firestore.firestore()
    
    func saveMealToGoogle(forFoods selectedFoods: [String], forDate dateString: String) {
        saveSymptomsToGoogle()
        saveFoodsToGoogle(forFoods: selectedFoods)
        refreshLocallyStoredHistoricalSymptomsList()
        
        if SelectedSymptomData.currentSessionSymptomsList.count != 0, selectedFoods.count != 0 {
            let googleFirebaseMeals = db.collection("meals")
            
            googleFirebaseMeals.addDocument(data: ["date": dateString, "symptoms": SelectedSymptomData.currentSessionSymptomsList, "foods": selectedFoods , "userId": "1234"]) { (error) in
                if let e = error {
                    print ("there was an error saving sympt om data \(e)")
                } else {
                    print ("Successfully saved meal data to the 'meals' table in Firebase.")
                }
            }
        }
    }
    
    func saveSymptomsToGoogle() {
        let symptomsCollectionReference = db.collection("users").document("51XvMBaVYmTNKNzuukJ7").collection("symptoms")
        
        for eachSymptom in SelectedSymptomData.currentSessionSymptomsList{
            if !SelectedSymptomData.historicalSymptomsList.contains(eachSymptom){
                symptomsCollectionReference.document(eachSymptom).setData(["userId": "1234", "name": eachSymptom]) { (error) in
                    if let e = error {
                        print ("there was an error saving symptom data \(e)")
                    } else {
                        print ("Successfully saved new symptom to the 'symptoms' sub-collection in Firebase.")
                    }
                }
            }
        }
    }
    
    func saveFoodsToGoogle(forFoods selectedFoods: [String]) {
        for eachSymptom in SelectedSymptomData.currentSessionSymptomsList {
            print ("eachSymptom is \(eachSymptom)")
            let foodsCollectionReference = db.collection("users").document("51XvMBaVYmTNKNzuukJ7").collection("symptoms").document(eachSymptom).collection("foods")
            
            for eachFood in selectedFoods{
                print ("eachFood is \(eachFood)")
                let foodDocumentReference = foodsCollectionReference.document(eachFood)
                foodDocumentReference.setData(["count": FieldValue.increment(1.0), "name": eachFood], merge: true) { (error) in
                    if let e = error {
                        print ("there was an error saving symptom data \(e)")
                    } else {
                        print ("Successfully saved food data to the 'foods' collection in Firebase.")
                    }
                }
            }
        }
    }
    
    //MARK:-- New data-model methods FOR LOADING data from Google Firebase
    
    func refreshLocallyStoredHistoricalSymptomsList() {
        let symptomsCollectionReference = db.collection("users").document("51XvMBaVYmTNKNzuukJ7").collection("symptoms")
        
        symptomsCollectionReference.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let symptomTitle = data["name"] as? String {
                        if !SelectedSymptomData.historicalSymptomsList.contains(symptomTitle){
                            SelectedSymptomData.historicalSymptomsList.append(symptomTitle)
                        }
                    }
                }
            }
        }
    }
}
