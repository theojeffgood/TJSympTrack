//
//  RelevantSymptomsViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/29/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import Firebase

class RelevantSymptomsViewController: UIViewController, UITableViewDelegate {
    
    lazy var googleDataManager = GoogleDataManager()
    var googleLoadDataHack = GoogleLoadDataHack()
    lazy var selectedSymptoms = [Symptom]()
    lazy var flattenedSymptomsArray: [String] = []
    lazy var relevantFoods: [String] = []
    lazy var dateString: String = ""
    lazy var usersSelectedSymptom = ""
    
    @IBOutlet weak var relevantSymptomsList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        relevantSymptomsList.dataSource = self
        relevantSymptomsList.delegate = self
        relevantSymptomsList.reloadData()
        relevantSymptomsList.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        googleLoadDataHack.delegate = self
        googleDataManager.delegate = self
        googleDataManager.loadSymptomsData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.viewAnalyticsSegue {
            let destinationVC = segue.destination as! AnalyticsViewController
            destinationVC.relevantFoods = relevantFoods
            destinationVC.selectedSymptom = usersSelectedSymptom
        }
    }
    
    func getFoodsAndCountsForSymptom(symptom: String){
        //        THINK ABOUT TRANSFERING THIS FUNCTION TO THE ANALYTICS VIEWCONTROLLER TO POPULATE PIE CHART
        //        let asdf = googleDataManager.
    }
    
    func displaySearchResults(symptomsData: [Symptom]){
        for eachSymptom in symptomsData {
            if !flattenedSymptomsArray.contains(eachSymptom.title!) {
                flattenedSymptomsArray.append(eachSymptom.title!)
            }
        }
        relevantSymptomsList.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        usersSelectedSymptom = flattenedSymptomsArray[indexPath.row]
        
        googleLoadDataHack.loadUpDates(searchSymptom: usersSelectedSymptom)
        
        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: K.viewAnalyticsSegue, sender: self)
        getFoodsAndCountsForSymptom(symptom: usersSelectedSymptom)
    }
}

//MARK: - UITableView Source

extension RelevantSymptomsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SymptomCell
        let latestSymptom = flattenedSymptomsArray[indexPath.row]
        
        cell.symptomLabel?.text = latestSymptom
        cell.symptomCheckmark.isHidden = true
        cell.symptomCheckCircle.isHidden = true
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flattenedSymptomsArray.count
    }
}


//MARK: - GoogleDataManager Delegate

extension RelevantSymptomsViewController: GoogleManagerDelegate {
    
    func didRetrieveSymptomData(symptomsData: [Symptom]) {
        DispatchQueue.main.async {
            self.displaySearchResults(symptomsData: symptomsData)
        }
    }
    
    //    THINK ABOUT TRANSFERING THIS FUNCTION TO THE ANALYTICS VIEWCONTROLLER TO POPULATE PIE CHART
    
    func didRetrieveFoodData(foodsData: [Food]) {
        relevantFoods = foodsData.map({ return $0.title! })
        performSegue(withIdentifier: K.viewAnalyticsSegue, sender: self)
    }
    
    func didFailWithError(error: Error) {
        print ("There was an error retrieving data from the Google Cloud: \(error)")
    }
}

//MARK: - GoogleDataManager Delegate

extension RelevantSymptomsViewController: GoogleLoadDataHackDelegate {
    
    func loadUpDates(resrictionDates: [String]) {
        if resrictionDates.count != 0 {
            googleDataManager.loadFoodData(resrictionDates: resrictionDates)
        }
    }
}
