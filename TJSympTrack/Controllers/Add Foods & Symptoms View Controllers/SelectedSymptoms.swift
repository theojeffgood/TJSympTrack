//
//  SelectedSymptoms.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import CoreData

class SelectedSymptomsViewController: UIViewController, UITableViewDelegate {
    
    var selectedSymptoms = [Symptom]()
    
    @IBOutlet weak var selectedSymptomsList: SelfSizedTableView!
    @IBOutlet weak var addFoodButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSymptomsList.dataSource = self
        selectedSymptomsList.delegate = self
        selectedSymptomsList.reloadData()
        selectedSymptomsList.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        selectedSymptomsList.estimatedRowHeight = 40
        selectedSymptomsList.invalidateIntrinsicContentSize()
    }
    
    @IBAction func addMoreSymptomsPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFoodPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.addNewFoodSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.addNewFoodSegue {
            for eachSymptom in selectedSymptoms {
                SelectedSymptomData.currentEntryTableHeaders.append(eachSymptom.title!)
            }
        }
    }
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usersSelectedRow = selectedSymptoms[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        usersSelectedRow.isChecked = !usersSelectedRow.isChecked
        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .none)
        
        if selectedSymptoms.count == 0 {
            addFoodButton.isEnabled = false
            addFoodButton.alpha = 0.55
        } else {
            addFoodButton.isEnabled = true
            addFoodButton.alpha = 1.0
        }
    }
}

//MARK: - UITableViewSource

extension SelectedSymptomsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedSymptoms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SymptomCell
        let latestSymptom = selectedSymptoms[indexPath.row]
        cell.symptomLabel?.text = latestSymptom.title
        
        if latestSymptom.isChecked {
            cell.symptomCheckmark.isHidden = false
        } else {
            cell.symptomCheckmark.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
