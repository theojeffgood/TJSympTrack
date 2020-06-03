//
//  ViewEntryViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import CoreData

class ViewEntryViewController: UIViewController, UITableViewDelegate{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedFoods = [String]()
    var selectedSymptoms = [String]()
    var monthString: String = ""
    var loadMealDataFromGoogle = LoadMealDataFromGoogle()
    var dateString = "March 12"
    
    @IBOutlet weak var viewEntryTableView: SelfSizedTableView3!
    @IBOutlet weak var entryDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewEntryTableView.delegate = self
        viewEntryTableView.dataSource = self
        viewEntryTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        entryDateLabel.text = ("\(monthString)th")
        viewEntryTableView.invalidateIntrinsicContentSize()
        viewEntryTableView.estimatedRowHeight = 75
        viewEntryTableView.reloadData()
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        selectedSymptoms = []
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - UITableViewSource

extension ViewEntryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return selectedSymptoms[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedSymptoms.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.contentView.backgroundColor = UIColor.white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SymptomCell
        let foodString = selectedFoods.joined(separator: ", ")

        cell.symptomLabel?.text = foodString
        cell.symptomCheckmark.isHidden = true
        cell.symptomCheckCircle.isHidden = true
        return cell
    }
}

//MARK: - GoogleDataManager Delegate

extension ViewEntryViewController: LoadMealDataFromGoogleDelegate {
    func didRetrieveMealData(symptomsTitles: [String], foodsTitles: [String], mealDateTitle: String) {
        selectedSymptoms = symptomsTitles
        selectedFoods = foodsTitles
        viewEntryTableView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        print ("There was an error retrieving data from the Google Cloud: \(error)")
    }
}
