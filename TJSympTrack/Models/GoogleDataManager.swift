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

struct GoogleDataManager {
   
   let db = Firestore.firestore()
   
   func createUserIfNoneExists(){
      let defaults = UserDefaults.standard
      let uuid = defaults.string(forKey: "userId")
      
      if uuid == nil {
         let userDocumentReference = db.collection("users").document()
         let previouslyStoredUserId = userDocumentReference.documentID
         defaults.set(previouslyStoredUserId, forKey: "userId")
         userDocumentReference.setData(["userId" : previouslyStoredUserId])
         UserData.userId = previouslyStoredUserId
      } else {
         UserData.userId = uuid
      }
   }
   
   func saveMealToGoogle(forFoods selectedFoods: [String], forDate dateString: String) {
      saveSymptomsToGoogle()
      saveFoodsToGoogle(forFoods: selectedFoods)
      refreshLocallyStoredHistoricalSymptomsList()
      
      if UserData.userId != nil, !SelectedSymptomData.currentSessionSymptomsList.isEmpty, !selectedFoods.isEmpty {
         let googleFirebaseMeals = db.collection("meals")
         
         googleFirebaseMeals.addDocument(data: ["date": dateString, "symptoms": SelectedSymptomData.currentSessionSymptomsList, "foods": selectedFoods , "userId": UserData.userId!]) { (error) in
            if let e = error {
               print ("there was an error saving sympt om data \(e)")
            } else {
               print ("Successfully saved meal data to the 'meals' table in Firebase.")
            }
         }
      }
   }
   
   func saveSymptomsToGoogle() {
      if UserData.userId != nil {
         let symptomsCollectionReference = db.collection("users").document(UserData.userId!).collection("symptoms")
         
         for eachSymptom in SelectedSymptomData.currentSessionSymptomsList{
            if !SelectedSymptomData.historicalSymptomsList.contains(eachSymptom){
               symptomsCollectionReference.document(eachSymptom).setData(["userId": UserData.userId!, "name": eachSymptom]) { (error) in
                  if let e = error {
                     print ("there was an error saving symptom data \(e)")
                  } else {
                     print ("Successfully saved new symptom to the 'symptoms' sub-collection in Firebase.")
                  }
               }
            }
         }
      }
   }
   
   func saveFoodsToGoogle(forFoods selectedFoods: [String]) {
      if UserData.userId != nil, !selectedFoods.isEmpty {
         for eachSymptom in SelectedSymptomData.currentSessionSymptomsList {
            let foodsCollectionReference = db.collection("users").document(UserData.userId!).collection("symptoms").document(eachSymptom).collection("foods")
            
            for eachFood in selectedFoods{
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
   }
   
   //MARK:-- New data-model methods FOR LOADING data from Google Firebase
   
   func refreshLocallyStoredHistoricalSymptomsList() {
      if UserData.userId != nil {
         let symptomsCollectionReference = db.collection("users").document(UserData.userId!).collection("symptoms")
         
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
}
