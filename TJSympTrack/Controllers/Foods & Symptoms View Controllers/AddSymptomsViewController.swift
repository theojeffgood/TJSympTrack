//
//  AddSymptomsViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import CoreData

class AddSymptomsViewController: UIViewController, UITableViewDelegate {
   
   var universeOfSymptoms = [[Symptom](),[Symptom]()]
   var usersCurrentExperiencingSymptoms: [String] = []
   
   @IBOutlet weak var symptomsList: UITableView!
   @IBOutlet weak var addSymptomsButton: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      symptomsList.dataSource = self
      symptomsList.delegate = self
      symptomsList.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
      symptomsList.reloadData()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      universeOfSymptoms = TJSymptomsBrain.loadSymptoms()
      if universeOfSymptoms[1].isEmpty && universeOfSymptoms[0].count != 7{
         populateCommonSymptoms()
      }
   }
   
   @IBAction func closeAddSymptomsPressed(_ sender: UIButton) {
      clearUnSelectedSymptoms()
      resetUsersSelection()
      dismiss(animated: true, completion: nil)
   }
   
   @IBAction func addSymptomsPressed(_ sender: UIButton) {
      let theUserHasMadeASelection = !universeOfSymptoms[0].isEmpty
      if theUserHasMadeASelection {
         clearUnSelectedSymptoms()
         dismiss(animated: true, completion: nil)
      } else {
         displayAnErrorMessage()
      }
   }
   
   func populateCommonSymptoms() {
      let baseSymptoms = ["Abdominal Pain","Bloating","Coughing","Dizziness","Hives","Inflamed Taste Buds","Itchy Mouth"]
      let preExistingSymptoms = universeOfSymptoms[0].map({ return $0.title }) + universeOfSymptoms[1].map({ return $0.title })
      
      for eachSymptom in baseSymptoms {
         if !(preExistingSymptoms.contains(eachSymptom)){
            let newSymptom = Symptom(context: TJSymptomsBrain.context)
            newSymptom.title = eachSymptom
            newSymptom.isChecked = false
            self.universeOfSymptoms[1].append(newSymptom)
         } else {
            usersCurrentExperiencingSymptoms.append(eachSymptom)
         }
      }
      TJSymptomsBrain.saveContext()
   }
   
   func resetUsersSelection(){
      var symptomCount = universeOfSymptoms[0].count - 1
      for eachSymptom in universeOfSymptoms[0] {
         TJSymptomsBrain.context.delete(eachSymptom)
         universeOfSymptoms[0].remove(at: symptomCount)
         symptomCount -= 1
      }
      for eachNewSymptom in usersCurrentExperiencingSymptoms {
         let newSymptom = Symptom(context: TJSymptomsBrain.context)
         newSymptom.title = eachNewSymptom
         newSymptom.isChecked = true
         self.universeOfSymptoms[0].append(newSymptom)
      }
      TJSymptomsBrain.saveContext()
   }
   
   func clearUnSelectedSymptoms(){
      let unselectedSymptoms = universeOfSymptoms[1]
      var symptomItemCount = unselectedSymptoms.count - 1
      for eachSymptom in unselectedSymptoms {
         TJSymptomsBrain.context.delete(eachSymptom)
         universeOfSymptoms[1].remove(at: symptomItemCount)
         symptomItemCount -= 1
      }
      TJSymptomsBrain.saveContext()
   }
   
   func displayAnErrorMessage(){
      let alert = UIAlertController(title: "Please add your symptom(s)", message: nil, preferredStyle: .alert)
      let action = UIAlertAction(title: "Add Symptom", style: .default) { (action) in }
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
   }
   
   //MARK: - TableView Delegate Methods
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      
      let usersSelectedCell = universeOfSymptoms[indexPath.section][indexPath.row]
      usersSelectedCell.isChecked = !usersSelectedCell.isChecked
      tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .none)
      
      let newIndexpathSection: Int?
      let selectedSymptoms = universeOfSymptoms[0]
      let newButtonStatus = selectedSymptoms.isEmpty
      if indexPath.section == 0 {
         newIndexpathSection = 1
         if selectedSymptoms.count == 1 {
            setButtonStatus(toStatus: newButtonStatus)
         }
      } else {
         newIndexpathSection = 0
         if selectedSymptoms.isEmpty {
            setButtonStatus(toStatus: newButtonStatus)
         }
      }
      universeOfSymptoms[indexPath.section].remove(at: indexPath.row)
      universeOfSymptoms[newIndexpathSection!].insert(usersSelectedCell, at: 0) //move to top of array
      let destinationindexPath = NSIndexPath(row: 0, section: newIndexpathSection!)
      tableView.moveRow(at: indexPath, to: destinationindexPath as IndexPath)
      //        TJSymptomsBrain.saveContext()
   }
   
   func setButtonStatus (toStatus status: Bool) {
      addSymptomsButton.isEnabled = status
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.275){
         self.symptomsList.reloadData()
      }
   }
}

//MARK: - UITableView Source

extension AddSymptomsViewController: UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SymptomCell
      let latestSymptom = universeOfSymptoms[indexPath.section][indexPath.row]
      cell.symptomLabel?.text = latestSymptom.title
      
      // Displays a cell's checkmark when its matching array<item> is checked
      cell.symptomCheckmark.isHidden = !(latestSymptom.isChecked)
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      return K.symptomsTableHeaders[section]
   }
   
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let headerView = UITableViewHeaderFooterView()
      headerView.contentView.backgroundColor = UIColor.white
      
      if !(universeOfSymptoms[section].isEmpty) {
         headerView.textLabel?.textColor = UIColor(named: K.BrandColors.blue)
      } else {
         headerView.textLabel?.textColor = UIColor.systemGray
      }
      return headerView
   }
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return K.symptomsTableHeaders.count
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return universeOfSymptoms[section].count
   }
}
