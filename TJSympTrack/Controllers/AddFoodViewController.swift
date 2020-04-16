//
//  AddFoodViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import CoreData

class AddFoodViewController: UIViewController, UITableViewDelegate{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var universeOfFood = [[Food](),[Food]()]
    var foodManager = FoodManager()
    var foodString = ""
    
    @IBOutlet weak var foodList: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var addFoodButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodList.register(UINib(nibName: K.foodCellNibName, bundle: nil), forCellReuseIdentifier: K.foodCellIdentifier)
        foodList.dataSource = self
        foodList.delegate = self
        foodManager.delegate = self
        searchBar.delegate = self
        
        universeOfFood = TJSymptomsBrain.loadFoods()
        resetFoodSearchResults()
        clearSelectedFoods()
        searchBar.becomeFirstResponder()
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(AddFoodViewController.didTapView))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        displaySearchbarAnimation()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFoodPressed(_ sender: Any) {
        performSegue(withIdentifier: K.completeEntrySegue, sender: self)
    }
    
    @objc func didTapView() {
        searchBar.resignFirstResponder()
        print ("didTapView")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.completeEntrySegue {
            let listOfSelectedFoods = universeOfFood[0].map({ return $0.title! })
            let destinationVC = segue.destination as! CompleteEntryViewController
            
            destinationVC.selectedFoods = listOfSelectedFoods
            resetFoodSearchResults()
            clearSelectedFoods()
        }
    }
    
    //    This block animates the Searchbar Placeholder text
    func displaySearchbarAnimation() {
        searchBar.placeholder = ""
        let searchText = K.searchbarPlaceholder
        var charIndex = 0.0
        for eachLetter in searchText{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.07 * charIndex){
                self.searchBar.placeholder?.append(eachLetter)
            }
            charIndex += 1
        }
    }
    
    func displaySearchResults(food: FoodData){
        var uniqueFoodsList: [String] = []
        for eachFood in food.common {
            if !uniqueFoodsList.contains(eachFood.tag_id) {
                let newFood = Food(context: self.context)
                newFood.id = eachFood.tag_id
                newFood.title = eachFood.tag_name
                newFood.isChecked = false
                newFood.imageUrl = eachFood.photo.thumb
                uniqueFoodsList.append(eachFood.tag_id)
                universeOfFood[1].append(newFood)
            }
        }
        TJSymptomsBrain.saveContext()
        foodList.reloadData()
    }
    
    func clearSelectedFoods(){
        let selectedFoods = universeOfFood[0]
        
        if selectedFoods.count > 0 {
            var foodItemCount = selectedFoods.count - 1
            for eachFoodItem in selectedFoods {
                context.delete(eachFoodItem)
                universeOfFood[0].remove(at: foodItemCount)
                foodItemCount -= 1
            }
            TJSymptomsBrain.saveContext()
        }
    }
    
    func resetFoodSearchResults(){
        let commonFoods = universeOfFood[1]
        
        if commonFoods.count > 0 {
            var foodItemCount = commonFoods.count - 1
            for eachFoodItem in commonFoods {
                context.delete(eachFoodItem)
                universeOfFood[1].remove(at: foodItemCount)
                foodItemCount -= 1
            }
            TJSymptomsBrain.saveContext()
        }
    }
    
    func setButtonStatus (toStatus status: Bool) {
        addFoodButton.isEnabled = status
        if status == true {
            addFoodButton.alpha = 1.0
        } else {
            addFoodButton.alpha = 0.55
        }
    }
    
    //MARK: - TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let usersSelectedCell = universeOfFood[indexPath.section][indexPath.row]
        usersSelectedCell.isChecked = !usersSelectedCell.isChecked
        tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .none)
        
        let selectedFoods = universeOfFood[0]
        let newButtonStatus = selectedFoods.isEmpty
        let newIndexpathSection: Int?
        if indexPath.section == 0 {
            newIndexpathSection = 1
            if selectedFoods.count == 1 {
                setButtonStatus(toStatus: newButtonStatus)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.275){
                    self.foodList.reloadData()
                }
            }
        } else {
            newIndexpathSection = 0
            if selectedFoods.isEmpty {
                setButtonStatus(toStatus: newButtonStatus)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.275){
                    self.foodList.reloadData()
                }
            }
        }
        universeOfFood[indexPath.section].remove(at: indexPath.row)
        universeOfFood[newIndexpathSection!].insert(usersSelectedCell, at: 0) //move to top of array
        let destinationindexPath = NSIndexPath(row: 0, section: newIndexpathSection!)
        tableView.moveRow(at: indexPath, to: destinationindexPath as IndexPath)
        TJSymptomsBrain.saveContext()
    }
}

//MARK: - TableView Data Source

extension AddFoodViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return K.foodTableHeaders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return universeOfFood[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.foodCellIdentifier, for: indexPath) as! FoodCell
        let latestFood = universeOfFood[indexPath.section][indexPath.row]
        
        cell.foodLabel?.text = latestFood.title
        
        if latestFood.isChecked {
            cell.foodCheckmark.isHidden = false
        } else {
            cell.foodCheckmark.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let selectedFoods = universeOfFood[0]
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: K.BrandColors.gray)
        
        let sectionLabel = UILabel(frame: CGRect(x: 8, y: 20, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        //        sectionLabel.font = UIFont(name: "System", size: 15)
        sectionLabel.textColor = UIColor(named: K.BrandColors.blue)
        sectionLabel.text = K.foodTableHeaders[section]
        sectionLabel.sizeToFit()
        if selectedFoods.isEmpty && section == 0 {
            sectionLabel.textColor = UIColor.systemGray
        }
        
        headerView.addSubview(sectionLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}

//MARK: - UISearchBar Delegate

extension AddFoodViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        resetFoodSearchResults()
        foodList.reloadData()
        print ("textFieldShouldClear")
        searchBar.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print ("textFieldDidEndEditing")
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let foodItem = searchBar.text {
            if foodItem.count >= 2 {
                foodManager.fetchFoods(foodItem)
            } else if foodItem.count == 0 {
                resetFoodSearchResults()
                foodList.reloadData()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
        print ("textFieldShouldReturn")
        return false
    }
}

//MARK: - FoodManager Delegate

extension AddFoodViewController: FoodManagerDelegate {
    
    func didUpdateFood(food: FoodData){
        DispatchQueue.main.async {
            if let foodItem = self.searchBar.text {
                if foodItem.count >= 2 {
                    self.resetFoodSearchResults()
                    self.foodList.reloadData()
                    self.displaySearchResults(food: food)
                }
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
