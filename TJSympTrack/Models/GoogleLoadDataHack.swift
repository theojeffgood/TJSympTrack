//
//  GoogleLoadDataHack.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 5/6/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol GoogleLoadDataHackDelegate {
    func loadUpDates(resrictionDates: [String])
//    func didFailWithError(error: Error)
}

struct GoogleLoadDataHack {
    
    var delegate: GoogleLoadDataHackDelegate?
    let db = Firestore.firestore()
    
    func loadUpDates(searchSymptom: String) {
        var dateList = [String]()
        let dateListQuery =  db.collection(K.FStore.symptomsCollectionName).whereField(K.FStore.symptomField, isEqualTo: searchSymptom)
        
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
                self.delegate?.loadUpDates(resrictionDates: dateList)
            }
        }
    }
}
