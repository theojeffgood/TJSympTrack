//
//  CompleteEntryViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import RealmSwift
//import Firebase

class CompleteEntryViewController: UIViewController, UITableViewDelegate{
   
//   let db = Firestore.firestore()
   //   var selectedFoods: [String] = []
   var foodString = ""
   var selectedFoods: [Results<Food>]? {
      didSet {
         for foodItem in selectedFoods![0] {
            foodString += foodItem.title
         }
      }
   }
   lazy var dateString: String = ""
   lazy var googleDataManager = GoogleDataManager()
   
   @IBOutlet weak var completedEntryTableView: UITableView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      completedEntryTableView.delegate = self
      completedEntryTableView.dataSource = self
      completedEntryTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      completedEntryTableView.reloadData()
      completedEntryTableView.estimatedRowHeight = 75
      completedEntryTableView.invalidateIntrinsicContentSize()
      getCurrentDate()
   }
   
   @IBAction func completeEntryButtonPressed(_ sender: UIButton) {
//      googleDataManager.saveMealToGoogle(forFoods: selectedFoods, forDate: dateString)
      SelectedSymptomData.currentSessionSymptomsList.removeAll()
      selectedFoods = []
      navigationController?.popToRootViewController(animated: true)
   }
   
   func getCurrentDate(){
      let date = Date()
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "MMMM d"
      dateString = dateFormatter.string(from: date)
   }
}

//MARK: - UITableViewSource

extension CompleteEntryViewController: UITableViewDataSource {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SymptomCell
//      let foodString = selectedFoods.joined(separator: ", ").capitalized
      cell.leftPaddingConstraint.constant = 20
//      cell.symptomLabel?.text = foodString
      cell.symptomCheckmark.isHidden = true
      cell.symptomCheckCircle.isHidden = true
      return cell
   }
   
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let symptomString = SelectedSymptomData.currentSessionSymptomsList.joined(separator: ", ")
      let headerLabel = TableViewHeaderLabel()
      headerLabel.text = symptomString
      return headerLabel
   }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return UITableView.automaticDimension
   }
   
   func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
      return 50.0
   }
}
