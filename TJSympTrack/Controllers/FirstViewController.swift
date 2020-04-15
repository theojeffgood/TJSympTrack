//
//  FirstViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    lazy var commonSymptoms = [Symptom]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadSymptoms()
        if appHasNeverBeenOpened() {
            createInitialSetOfSymptoms()
        }
    }

    @IBAction func AddSymptomsPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.addNewSymptomsSegue, sender: self)
    }
    
    func appHasNeverBeenOpened() -> Bool {
        if commonSymptoms.count == 0 {
            return true
        } else {return false}
    }
    
    func createInitialSetOfSymptoms(){
        let baseSymptoms = ["Abdominal Pain","Bloating","Coughing","Dizziness","Hives","Inflamed Taste Buds","Itchy Mouth"]
        
        for eachSymptom in baseSymptoms{
            let newSymptom = Symptom(context: self.context)
            newSymptom.title = eachSymptom
            newSymptom.isChecked = false
            self.commonSymptoms.append(newSymptom)
        }
        TJSymptomsBrain.saveContext()
    }

    func loadSymptoms(){
        let request: NSFetchRequest<Symptom> = Symptom.fetchRequest()
        
        do {
            commonSymptoms = try context.fetch(request)
        } catch{
            print("Error fetching data from context \(error)")
        }
    }
    
}
