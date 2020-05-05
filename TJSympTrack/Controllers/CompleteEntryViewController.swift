//
//  CompleteEntryViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class CompleteEntryViewController: UIViewController, UITableViewDelegate{

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let db = Firestore.firestore()
    var selectedFoods: [String] = []
    var foodString: String = ""
    lazy var dateString: String = ""
//    lazy var googleDataManager = GoogleDataManager()

    @IBOutlet weak var completedEntryTableView: SelfSizedTableView2!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completedEntryTableView.delegate = self
        completedEntryTableView.dataSource = self
        completedEntryTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        completedEntryTableView.invalidateIntrinsicContentSize()
        completedEntryTableView.estimatedRowHeight = 75
        convertFoodListToString()
        completedEntryTableView.reloadData()
        
        getCurrentDate()
    }
    
    @IBAction func completeEntryButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.submitEntrySegue, sender: self)
//        googleDataManager.saveEntryToGoogle(forFoods: selectedFoods, forDate: dateString)
        SelectedSymptomData.currentEntryTableHeaders = [""]
        selectedFoods = []
    }

    func getCurrentDate(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        dateString = dateFormatter.string(from: date)
    }
    
    func convertFoodListToString() {
        for eachFood in selectedFoods {
            foodString += ("\(eachFood)")
            if eachFood != selectedFoods.last! {
                foodString += ", "
            }
        }
        foodString = foodString.capitalized
    }
}

    //MARK: - UITableViewSource

    extension CompleteEntryViewController: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return SelectedSymptomData.currentEntryTableHeaders[section]
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return SelectedSymptomData.currentEntryTableHeaders.count
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
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UITableViewHeaderFooterView()  
            headerView.contentView.backgroundColor = UIColor.white
            return headerView
        }
    }
