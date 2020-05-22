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
    var unselectedSymptoms = [Symptom]()
    var segueDestination: String?
    
    @IBOutlet weak var selectedSymptomsList: SelfSizedTableView!
    @IBOutlet weak var addFoodButton: UIButton!
    @IBOutlet weak var addMoreSymptomsButton: UIButton!
    @IBOutlet weak var userInstructionsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSymptomsList.dataSource = self
        selectedSymptomsList.delegate = self
        selectedSymptomsList.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        loadSymptoms()
        setupView()
        selectedSymptomsList.reloadData()
        selectedSymptomsList.estimatedRowHeight = 40
        selectedSymptomsList.invalidateIntrinsicContentSize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func modalDismissed(segue: UIStoryboardSegue) {
      // You can use segue.source to retrieve the VC
      // being dismissed to collect any data which needs
      // to be processed 
    }
    
    @IBAction func addMoreSymptomsPressed(_ sender: UIButton) {
        TJSymptomsBrain.saveContext()
        performSegue(withIdentifier: K.addNewSymptomsSegue, sender: self)
    }
    
    @IBAction func addFoodPressed(_ sender: UIButton) {
        if let safeSegueDestination = segueDestination {
            performSegue(withIdentifier: safeSegueDestination, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.addNewFoodSegue {
            let usersCurrentExperiencingSymptoms = selectedSymptoms.filter( {$0.isChecked == true }).map({ return $0 })
            for eachSymptom in usersCurrentExperiencingSymptoms {
                SelectedSymptomData.currentEntryTableHeaders.append(eachSymptom.title!)
            }
        } else if segue.identifier == K.addNewSymptomsSegue {
            for symptom in selectedSymptoms where symptom.isChecked == false {
                symptom.isChecked = !symptom.isChecked
            }
        }
    }
    
    func loadSymptoms(){
        print("loadSymptomsCalled. current symptoms count is: \(selectedSymptoms.count)")
        let request: NSFetchRequest<Symptom> = Symptom.fetchRequest()
        
        do {
            selectedSymptoms = try TJSymptomsBrain.context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        print("new symptoms count is: \(selectedSymptoms.count)")
    }
    
    func setupView(){
        if selectedSymptoms.isEmpty {
            addFoodButton.setTitle("Add Symptoms", for: .normal)
            segueDestination = K.addNewSymptomsSegue
            addMoreSymptomsButton.isHidden = true
            userInstructionsLabel.isHidden = true
        } else {
            addFoodButton.setTitle("Add Foods", for: .normal)
            segueDestination = K.addNewFoodSegue
        }
    }
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usersSelectedRow = selectedSymptoms[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        usersSelectedRow.isChecked = !usersSelectedRow.isChecked
        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .none)
        
        let usersCurrentExperiencingSymptoms = selectedSymptoms.filter( {$0.isChecked == true }).map({ return $0 })
        addFoodButton.isEnabled = (usersCurrentExperiencingSymptoms.isEmpty ? false : true)
    }
}

//MARK: - UITableViewSource

extension SelectedSymptomsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedSymptoms.isEmpty {
            //            tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 250)
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
