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
    
    func loadFoodData(forSymptom: Symptom? = nil, searchDate: String? = nil) {
        var query: Query?
        var saveFoods = [Food]()
        let searchReference = db.collection(K.FStore.foodCollectionName)
        
        if let safeSearchDate = searchDate {
            query = searchReference.whereField(K.FStore.dateField, isEqualTo: safeSearchDate)
        } else if let safeSearchSymptom = forSymptom {
            let resrictionDates = loadUpDates(searchSymptom: safeSearchSymptom)
            query = searchReference.whereField(K.FStore.symptomField, in: resrictionDates)
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
                            let newFood = Food(context: self.context)
                            newFood.title = foodTitle
                            newFood.isChecked = false
                            saveFoods.append(newFood)
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
    
    func loadUpDates(searchSymptom: Symptom) -> [String] {
        var dateList = [String]()
        let dateListQuery = db.collection(K.FStore.symptomsCollectionName).whereField(K.FStore.symptomField, isEqualTo: searchSymptom)
        
        dateListQuery.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let entryDate = data[K.FStore.dateField] as? String {
                        if !dateList.contains(entryDate) {
                            dateList.append(entryDate)
                        }
                    }
                }
            }
            //            DispatchQueue.main.async {
            ////                RESUME THE MAIN LOADING FUNCTION WITH THIS DATE ARRAY
            //            }
        }
        return dateList
    }
    
    func loadSymptomsData(searchDate: String? = nil) {
        var savedSymptoms = [Symptom]()
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
                            let newSymptom = Symptom(context: self.context)
                            newSymptom.title = symptomTitle
                            newSymptom.isChecked = false
                            savedSymptoms.append(newSymptom)
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
