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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var universeOfSymptoms = [[Symptom](),[Symptom]()]
    
    @IBOutlet weak var symptomsList: UITableView!
    @IBOutlet weak var addSymptomsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        symptomsList.dataSource = self
        symptomsList.delegate = self
        symptomsList.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        universeOfSymptoms = TJSymptomsBrain.loadSymptoms()
        symptomsList.reloadData()
    }
    
    @IBAction func closeAddSymptomsPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addSymptomsPressed(_ sender: UIButton) {
        if theUserHasMadeASelection() {
            self.performSegue(withIdentifier: K.reviewSymptomsAddedSegue, sender: self)
        } else {displayAnErrorMessage()}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let usersSelectedSymptoms = universeOfSymptoms[0]
        
        if segue.identifier == K.reviewSymptomsAddedSegue {
            let destinationVC = segue.destination as! SelectedSymptomsViewController
            destinationVC.selectedSymptoms = usersSelectedSymptoms
        }
    }
    
    func theUserHasMadeASelection() -> Bool {
        let countOfSelectedSymptoms = universeOfSymptoms[0].count
        
        if countOfSelectedSymptoms != 0 {
            return true
        } else {return false}
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
        TJSymptomsBrain.saveContext()
    }
    
    func setButtonStatus (toStatus status: Bool) {
        addSymptomsButton.isEnabled = status
        addSymptomsButton.alpha = (addSymptomsButton.isEnabled ? 1.0 : 0.55)
        
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
        
        // Displays the cell's checkmark when corresponding array.item is checked
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
