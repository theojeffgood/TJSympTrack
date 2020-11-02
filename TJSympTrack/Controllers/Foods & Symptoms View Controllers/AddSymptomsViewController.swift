//
//  AddSymptomsViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import RealmSwift

class AddSymptomsViewController: UIViewController, UITableViewDelegate {
   
   let realm = try! Realm()
   
   var universeOfSymptoms: [Results<Symptom>] {
      get {
         let checkedItemsPredicate = NSPredicate(format: "isChecked == true", argumentArray: nil)
         let uncheckedItemsPredicate = NSPredicate(format: "isChecked == false", argumentArray: nil)
         let checkedItems = realm.objects(Symptom.self).filter(checkedItemsPredicate)
         let uncheckedItems = realm.objects(Symptom.self).filter(uncheckedItemsPredicate)
         return [checkedItems,uncheckedItems]
      }
//      set {
//         symptomsList.reloadData()
//      }
   }
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
//      universeOfSymptoms = TJSymptomsBrain.loadSymptoms()
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
//      let preExistingSymptoms = universeOfSymptoms[0].map({ return $0.title }) + universeOfSymptoms[1].map({ return $0.title })
      
      let preExistingSymptoms = universeOfSymptoms[0].map({ return $0.title })
      
      for eachSymptom in baseSymptoms {
         if !(preExistingSymptoms.contains(eachSymptom)){
            let newSymptom = Symptom()
            newSymptom.title = eachSymptom
            newSymptom.isChecked = false
//            self.universeOfSymptoms[1].append(newSymptom)
            TJSymptomsBrain.saveSymptoms(symptom: newSymptom)
         } else {
            usersCurrentExperiencingSymptoms.append(eachSymptom)
         }
      }
//      TJSymptomsBrain.saveContext()
   }
   
   func resetUsersSelection(){
      var symptomCount = universeOfSymptoms[0].count - 1
      for eachSymptom in universeOfSymptoms[0] {
         TJSymptomsBrain.deleteSymptoms(symptom: (eachSymptom))
//         universeOfSymptoms[0].remove(at: symptomCount)
         symptomCount -= 1
      }
      for eachNewSymptom in usersCurrentExperiencingSymptoms {
         let newSymptom = Symptom()
         newSymptom.title = eachNewSymptom
         newSymptom.isChecked = true
//         self.universeOfSymptoms[0].append(newSymptom)
         TJSymptomsBrain.saveSymptoms(symptom: newSymptom)
      }
//      TJSymptomsBrain.saveSymptoms(symptom: newSymptom)
   }
   
   func clearUnSelectedSymptoms(){
      let unselectedSymptoms = universeOfSymptoms[1]
//      var symptomItemCount = unselectedSymptoms.count - 1
      for eachSymptom in unselectedSymptoms {
//         TJSymptomsBrain.context.delete(eachSymptom)
         TJSymptomsBrain.deleteSymptoms(symptom: eachSymptom)
//         universeOfSymptoms[1].remove(at: symptomItemCount)
//         universeOfSymptoms[1].removeLast()
//         symptomItemCount -= 1
      }
//      TJSymptomsBrain.saveContext()
   }
   
   func displayAnErrorMessage(){
      let alert = UIAlertController(title: "Please add your symptom(s)", message: nil, preferredStyle: .alert)
      let action = UIAlertAction(title: "Add Symptom", style: .default) { (action) in }
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
   }
   
   //MARK: - TableView Delegate Methods
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let usersSelectedSymptoms = universeOfSymptoms[0]
      let newIndexPath: IndexPath?
      if indexPath.section == 0 {
         newIndexPath = [1, 0]
         if usersSelectedSymptoms.count == 1 {
            addSymptomsButton.deactivateButton()
         }
      } else {
         newIndexPath = [0, universeOfSymptoms[0].count]
         if usersSelectedSymptoms.isEmpty {
            addSymptomsButton.activateButton()
            tableView.reloadSections([0], with: .none)
         }
      }

      let usersSelectedCell = universeOfSymptoms[indexPath.section][indexPath.row]
      try! realm.write{
         usersSelectedCell.isChecked = !usersSelectedCell.isChecked
      }
      guard let cell = tableView.cellForRow(at: indexPath) as? SymptomCell else {return}
      cell.symptomCheckmark.isHidden = !(usersSelectedCell.isChecked)
            
      tableView.deselectRow(at: indexPath, animated: true)
      tableView.moveRow(at: indexPath, to: newIndexPath ?? [0, 0])
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
      headerView.textLabel?.textColor = UIColor(named: K.BrandColors.blue)
      
      return headerView
   }
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return K.symptomsTableHeaders.count
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return universeOfSymptoms[section].count
   }
}
