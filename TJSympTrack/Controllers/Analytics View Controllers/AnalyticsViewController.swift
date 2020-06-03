//
//  RelevantSymptomsViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/29/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import Firebase

class AnalyticsViewController: UIViewController, UITableViewDelegate {
    
    
    lazy var selectedSymptoms = [Symptom]()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        relevantSymptomsList.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.viewAnalyticsSegue {
            let destinationVC = segue.destination as! PieChartViewController
            destinationVC.loadFoodDataFromGoogle.delegate = destinationVC
            destinationVC.loadFoodDataFromGoogle.loadPreExistingFoods(forSymptoms: [usersSelectedSymptom])
            destinationVC.selectedSymptom = usersSelectedSymptom
        }
    }
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        usersSelectedSymptom = SelectedSymptomData.historicalSymptomsList[indexPath.row]
        
//        loadFoodDataFromGoogle.loadPreExistingFoods(forSymptoms: [usersSelectedSymptom])
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.viewAnalyticsSegue, sender: self)
    }
}

//MARK: - UITableView Source

extension AnalyticsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SymptomCell
        let latestSymptom = SelectedSymptomData.historicalSymptomsList[indexPath.row]
        
        cell.symptomLabel?.text = latestSymptom
        cell.symptomCheckmark.isHidden = true
        cell.symptomCheckCircle.isHidden = true
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectedSymptomData.historicalSymptomsList.count
    }
}
