//
//  SelectedSymptoms.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import RealmSwift

class SelectedSymptomsViewController: UIViewController, UITableViewDelegate {
   
   let realm = try! Realm()
   
   var selectedSymptoms: Results<Symptom> {
      get {
//         let predicate = NSPredicate(format: "isChecked == true", argumentArray: nil)
//         return realm.objects(Symptom.self).filter(predicate)
         return realm.objects(Symptom.self)
      }
      set {
         selectedSymptomsList.reloadData()
      }
   }
   
   var segueDestination: String?
   let googleDataManager = GoogleDataManager()
   lazy var defaultTableViewHeightConstraint: NSLayoutConstraint = selectedSymptomsList.heightAnchor.constraint(equalToConstant: 250)
   
   @IBOutlet weak var selectedSymptomsList: SelfSizedTableView!
   @IBOutlet weak var addFoodButton: UIButton!
   @IBOutlet weak var addMoreSymptomsButton: UIButton!
   @IBOutlet weak var userInstructionsLabel: UILabel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      selectedSymptomsList.dataSource = self
      selectedSymptomsList.delegate = self
      selectedSymptomsList.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
      
      googleDataManager.refreshLocallyStoredHistoricalSymptomsList()
      googleDataManager.createUserIfNoneExists()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      loadSymptoms()
      setupUI()
      selectedSymptomsList.reloadData()
      selectedSymptomsList.estimatedRowHeight = 40
      selectedSymptomsList.invalidateIntrinsicContentSize()
   }
   
   @IBAction func addMoreSymptomsPressed(_ sender: UIButton) {
//      TJSymptomsBrain.saveContext()
      performSegue(withIdentifier: K.addNewSymptomsSegue, sender: self)
   }
   
   @IBAction func addFoodPressed(_ sender: UIButton) {
      
      if let safeSegueDestination = segueDestination {
         performSegue(withIdentifier: safeSegueDestination, sender: self)
      }
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == K.addNewFoodSegue {
//         let usersCurrentExperiencingSymptoms = selectedSymptoms.filter( {$0.isChecked == true }).map({ return $0 })
         
         let predicate = NSPredicate(format: "isChecked == true", argumentArray: nil)
         let usersCurrentExperiencingSymptoms = realm.objects(Symptom.self).filter(predicate)
         
         SelectedSymptomData.currentSessionSymptomsList.removeAll()
         for eachSymptom in usersCurrentExperiencingSymptoms {
            SelectedSymptomData.currentSessionSymptomsList.append(eachSymptom.title)
         }
      } else if segue.identifier == K.addNewSymptomsSegue {
         for symptom in selectedSymptoms where symptom.isChecked == false {
            try! realm.write{
               symptom.isChecked = !symptom.isChecked
            }
         }
      }
   }
   
   func loadSymptoms(){
      let symptoms = realm.objects(Symptom.self)
      selectedSymptoms = symptoms.filter("isChecked == %@", true)
   }
   
   func setupUI(){
      if selectedSymptoms.isEmpty {
         addFoodButton.setTitle("Add Symptoms", for: .normal)
         segueDestination = K.addNewSymptomsSegue
         addMoreSymptomsButton.isHidden = true
         userInstructionsLabel.isHidden = true
         selectedSymptomsList.translatesAutoresizingMaskIntoConstraints = false
         defaultTableViewHeightConstraint.isActive = true
      } else {
         addFoodButton.setTitle("Add Foods", for: .normal)
         segueDestination = K.addNewFoodSegue
         addMoreSymptomsButton.isHidden = false
         userInstructionsLabel.isHidden = false
         defaultTableViewHeightConstraint.isActive = false
      }
   }
   
   //MARK: - TableView Delegate Methods
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let usersSelectedRow = selectedSymptoms[indexPath.row]
      
      tableView.deselectRow(at: indexPath, animated: true)
      
      try! realm.write {
         usersSelectedRow.isChecked = !usersSelectedRow.isChecked
      }
      
//      tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .none)
      
      let usersCurrentExperiencingSymptoms = selectedSymptoms.filter({$0.isChecked == true }).map({ return $0 })
      addFoodButton.isEnabled = (usersCurrentExperiencingSymptoms.isEmpty ? false : true)
      
      tableView.reloadData()
   }
}

//MARK: - UITableViewSource

extension SelectedSymptomsViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if selectedSymptoms.isEmpty {
         tableView.setEmptyMessage("Add the symptoms you experience. We'll figure our what foods are causing them!")
      } else {
         tableView.restore()
      }
      return selectedSymptoms.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SymptomCell
      let latestSymptom = selectedSymptoms[indexPath.row]
      cell.symptomLabel?.text = latestSymptom.title
      cell.symptomCheckmark.isHidden = latestSymptom.isChecked ? false : true
      return cell
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableView.automaticDimension
   }
}
