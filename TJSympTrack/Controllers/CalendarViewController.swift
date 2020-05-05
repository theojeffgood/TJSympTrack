//
//  CalendarViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class CalendarViewController: UIViewController {
    
//    let db = Firestore.firestore()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var symptoms: [Symptom] = []
    var foods: [Food] = []
    var googleDataManager = GoogleDataManager()
    var counter = 0
    var dateString: String = ""
    
    @IBOutlet weak var currentMonthLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func datePressed(_ sender: UIButton) {
        dateString = currentMonthLabel.text! + " " + sender.titleLabel!.text!
        performSegue(withIdentifier: K.viewEntrySegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.viewEntrySegue {
            let destinationVC = segue.destination as! ViewEntryViewController
            destinationVC.monthString = dateString
            destinationVC.googleDataManager.delegate = destinationVC
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
