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
    func didRetrieveSymptomData(symptomsData: [String])
    func didRetrieveFoodData(foodsData: [String])
    func didFailWithError(error: Error)
}

struct GoogleDataManager {
    
    var delegate: GoogleManagerDelegate?
    let db = Firestore.firestore()
    
    func loadFoodData(forSymptom: String? = nil, searchDate: String? = nil, resrictionDates: [String]? = nil) {
        var query: Query?
        var saveFoods = [String]()
        let searchReference = db.collection(K.FStore.foodCollectionName)
        
        if let safeSearchDate = searchDate {
            query = searchReference.whereField(K.FStore.dateField, isEqualTo: safeSearchDate)
        }
        else if let safeRestrictionDates = resrictionDates{
            query = searchReference.whereField(K.FStore.dateField, in: safeRestrictionDates)
        } else {
            return
        }
        
        if let safeQuery = query {
            safeQuery.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let foodTitle = data[K.FStore.foodField] as? String {
                            saveFoods.append(foodTitle)
                        }
                    }
                }
                self.delegate?.didRetrieveFoodData(foodsData: saveFoods)
            }
        } else {
            print ("Query was not properly created. This should never happen.")
            return
        }
    }
    
    func loadSymptomsData(searchDate: String? = nil) {
        var savedSymptoms = [String]()
        var query: Query?
        let searchReference = db.collection(K.FStore.symptomsCollectionName)
        
        if let safeSearchDate = searchDate {
            query = searchReference.whereField(K.FStore.dateField, isEqualTo: safeSearchDate)
        } else {
            query = searchReference.whereField(K.FStore.symptomField, in: ["Abdominal Pain","Bloating","Coughing","Dizziness","Hives","Inflamed Taste Buds","Itchy Mouth"])
        }
        
        if let safeQuery = query {
            safeQuery.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let symptomTitle = data[K.FStore.symptomField] as? String {
                            savedSymptoms.append(symptomTitle)
                        }
                    }
                    self.delegate?.didRetrieveSymptomData(symptomsData: savedSymptoms)
                }
            }
        }
        else {
            print ("Query was not properly created. This should never happen.")
            return
        }
    }
    
    func saveEntryToGoogle(forFoods selectedFoods: [String], forDate dateString: String) {
        if SelectedSymptomData.currentEntryTableHeaders.count != 0, selectedFoods.count != 0 {
            let googleFirebaseFoods = db.collection(K.FStore.foodCollectionName)
            let googleFirebaseSymptoms = db.collection(K.FStore.symptomsCollectionName)
            
            for eachSymptom in SelectedSymptomData.currentEntryTableHeaders {
                googleFirebaseSymptoms.addDocument(data: [K.FStore.symptomField: eachSymptom, K.FStore.dateField: dateString]) { (error) in
                    if let e = error {
                        print ("there was an error saving symptom data \(e)")
                    } else {
                        print ("Successfully saved data.")
                    }
                }
            }
            for eachFood in selectedFoods {
                googleFirebaseFoods.addDocument(data: [K.FStore.foodField: eachFood, K.FStore.dateField: dateString]) { (error) in
                    if let e = error {
                        print ("there was an error saving food data \(e)")
                    } else {
                        print ("Successfully saved data.")
                    }
                }
            }
        }
    }
}
