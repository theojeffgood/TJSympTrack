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
            self.performSegue(withIdentifier: "reviewSymptomsAdded", sender: self)
        } else {displayAnErrorMessage()}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let usersSelectedSymptoms = universeOfSymptoms[0]
        
        if segue.identifier == "reviewSymptomsAdded" {
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
        if indexPath.section == 0 {
            newIndexpathSection = 1
            if selectedSymptoms.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.275){
                    self.symptomsList.reloadData()
                }
            }
        } else {
            newIndexpathSection = 0
            if selectedSymptoms.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.275){
                    self.symptomsList.reloadData()
                }
            }
        }
        
        universeOfSymptoms[indexPath.section].remove(at: indexPath.row)
        universeOfSymptoms[newIndexpathSection!].insert(usersSelectedCell, at: 0) //move to top of array
        let destinationindexPath = NSIndexPath(row: 0, section: newIndexpathSection!)
        tableView.moveRow(at: indexPath, to: destinationindexPath as IndexPath)
        TJSymptomsBrain.saveContext()
        
        if universeOfSymptoms[0].count == 0 {
            addSymptomsButton.isEnabled = false
            addSymptomsButton.alpha = 0.55
        } else {
            addSymptomsButton.isEnabled = true
            addSymptomsButton.alpha = 1.0
        }
    }
}

//MARK: - UITableView Source

extension AddSymptomsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SymptomCell
        let latestSymptom = universeOfSymptoms[indexPath.section][indexPath.row]
        cell.symptomLabel?.text = latestSymptom.title
        
        if latestSymptom.isChecked {
            cell.symptomCheckmark.isHidden = false
        } else {
            cell.symptomCheckmark.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let selectedSymptoms = universeOfSymptoms[0]
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: K.BrandColors.gray)
        
        let sectionLabel = UILabel(frame: CGRect(x: 8, y: 20, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
//        sectionLabel.font = UIFont(name: "System", size: 15)
        sectionLabel.textColor = UIColor(named: K.BrandColors.blue)
        sectionLabel.text = K.symptomsTableHeaders[section]
        sectionLabel.sizeToFit()
        if selectedSymptoms.isEmpty && section == 0 {
            sectionLabel.textColor = UIColor.systemGray
        }
        headerView.addSubview(sectionLabel)
        
        return headerView

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return K.symptomsTableHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universeOfSymptoms[section].count
    }
    
}
