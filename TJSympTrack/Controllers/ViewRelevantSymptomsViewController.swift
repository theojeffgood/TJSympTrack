//
//  ViewRelevantSymptomsViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/29/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import Firebase
//import CoreData

class ViewRelevantSymptomsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var relevantSymptomsList: UITableView!
    
    lazy var selectedSymptoms = [Symptom]()
    lazy var googleDataManager = GoogleDataManager()
    lazy var relevantFoods: [String: Int] = [:]
    lazy var dateString: String = ""
    lazy var usersSelectedSymptom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        relevantSymptomsList.dataSource = self
        relevantSymptomsList.delegate = self
        relevantSymptomsList.reloadData()
        relevantSymptomsList.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        googleDataManager.delegate = self
        googleDataManager.loadSymptomsData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.viewAnalyticsSegue {
            let destinationVC = segue.destination as! AnalyticsViewController
//            destinationVC.populateChartDataSet(forFoods: relevantFoods)
            destinationVC.symptomInFocus.text = usersSelectedSymptom
        }
    }
    
    func getFoodsAndCountsForSymptom(symptom: String){
//        THINK ABOUT TRANSFERING THIS FUNCTION TO THE ANALYTICS VIEWCONTROLLER TO POPULATE PIE CHART
//        let asdf = googleDataManager.
    }
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        usersSelectedSymptom = selectedSymptoms[indexPath.row].title!
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.viewAnalyticsSegue, sender: self)
        
        getFoodsAndCountsForSymptom(symptom: usersSelectedSymptom)
    }
}

//MARK: - UITableView Source

extension ViewRelevantSymptomsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SymptomCell
        let latestSymptom = selectedSymptoms[indexPath.row]
        
        cell.symptomLabel?.text = latestSymptom.title
        cell.symptomCheckmark.isHidden = true
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSymptoms.count
    }
}


//MARK: - GoogleDataManager Delegate

extension ViewRelevantSymptomsViewController: GoogleManagerDelegate {

    func didRetrieveSymptomData(symptomsData: [Symptom]) {
        DispatchQueue.main.async {
            print ("didRetrieveSymptomData")
            self.selectedSymptoms = symptomsData
            self.relevantSymptomsList.reloadData()
        }
    }

    //    THINK ABOUT TRANSFERING THIS FUNCTION TO THE ANALYTICS VIEWCONTROLLER TO POPULATE PIE CHART

        func didRetrieveFoodData(foodsData: [Food]) {
//            relevantFoods = foodsData
//            relevantFoods = foodsData.map({ return $0.title! })
        }

    func didFailWithError(error: Error) {
        print ("There was an error retrieving data from the Google Cloud: \(error)")
    }
}
