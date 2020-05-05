//
//  Constants.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

struct K {
    static let searchbarPlaceholder = "Search"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "SymptomCell"
    static let foodCellIdentifier = "ReusableFoodCell"
    static let foodCellNibName = "FoodCell"
    static let addNewSymptomsSegue = "addSymptoms"
    static let addNewFoodSegue = "addFood"
    static let reviewSymptomsAddedSegue = "reviewSymptomsAdded"
    static let completeEntrySegue = "completeEntry"
    static let submitEntrySegue = "submitEntry"
    static let viewEntrySegue = "viewEntry"
    static let viewAnalyticsSegue = "viewAnalytics"
    static let symptomsTableHeaders = ["Selected Symptoms","Common Symptoms"]
    static let foodTableHeaders = ["Selected Foods","Common Foods"]
        
    struct BrandColors {
        static let gray = "BrandGray"
        static let blue = "BrandBlue"
    }
    
    struct FStore {
        static let foodCollectionName = "foods"
        static let symptomsCollectionName = "symptoms"
        static let symptomField = "symptom"
        static let foodField = "food"
        static let dateField = "date"
    }
}
