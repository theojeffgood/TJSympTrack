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

    let db = Firestore.firestore()
    var selectedFoods: [String] = []
    lazy var dateString: String = ""
    lazy var googleDataManager = GoogleDataManager()

    @IBOutlet weak var completedEntryTableView: SelfSizedTableView2!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        completedEntryTableView.delegate = self
        completedEntryTableView.dataSource = self
        completedEntryTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        completedEntryTableView.reloadData()
        completedEntryTableView.estimatedRowHeight = 75
        completedEntryTableView.invalidateIntrinsicContentSize()
        getCurrentDate()
    }
    
    @IBAction func completeEntryButtonPressed(_ sender: UIButton) {
        googleDataManager.saveEntryToGoogle(forFoods: selectedFoods, forDate: dateString)
        SelectedSymptomData.currentEntryTableHeaders = [""]
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
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            let symptomString = SelectedSymptomData.currentEntryTableHeaders.joined(separator: ", ")
            return symptomString
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! SymptomCell
            let foodString = selectedFoods.joined(separator: ", ").capitalized
            cell.leftPaddingConstraint.constant = 20
            cell.symptomLabel?.text = foodString
            cell.symptomCheckmark.isHidden = true
            cell.symptomCheckCircle.isHidden = true
            return cell
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let header = UITableViewHeaderFooterView()
            header.contentView.backgroundColor = UIColor.white
            header.textLabel?.frame = header.frame
            header.textLabel?.setFontSize()
            return header
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
            return 50.0
        }
}

extension UILabel {
    func setFontSize (){
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont.boldSystemFont(ofSize: 25)
    }
}
