//
//  ViewEntryViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class ViewEntryViewController: UIViewController, UITableViewDelegate, GoogleManagerDelegate{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let db = Firestore.firestore()
    var selectedFoods = [Food]()
    var selectedSymptoms = [Symptom]()
    var foodString: String = ""
    var monthString: String = ""

    @IBOutlet weak var viewEntryTableView: SelfSizedTableView3!
    @IBOutlet weak var entryDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewEntryTableView.delegate = self
        viewEntryTableView.dataSource = self
        viewEntryTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        convertFoodListToString()
        entryDateLabel.text = ("\(monthString)th")
        viewEntryTableView.invalidateIntrinsicContentSize()
        viewEntryTableView.estimatedRowHeight = 75
        viewEntryTableView.reloadData()
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        selectedSymptoms = []
        dismiss(animated: true, completion: nil)
    }
    
    func didRetrieveSymptomData(symptomsData: [Symptom]) {
        selectedSymptoms = symptomsData
        viewEntryTableView.reloadData()
    }
    
    func didRetrieveFoodData(foodsData: [Food]) {
        selectedFoods = foodsData
        viewEntryTableView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        print ("There was an error retrieving data from the Google Cloud: \(error)")
    }
    
    func convertFoodListToString() {
        for eachFood in selectedFoods {
            foodString += ("\(eachFood.title!)")
            if eachFood != selectedFoods.last! {
                foodString += ", "
            }
        }
        foodString = foodString.capitalized
    }
}

    //MARK: - UITableViewSource

    extension ViewEntryViewController: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return selectedSymptoms[section].title
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return selectedSymptoms.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SymptomCell
            cell.symptomLabel?.text = foodString
            cell.symptomCheckmark.isHidden = true
            cell.symptomCheckCircle.isHidden = true
            return cell
        }
    }
