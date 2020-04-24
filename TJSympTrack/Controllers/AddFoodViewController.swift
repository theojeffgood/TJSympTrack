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
    
    var imageCache: [String: UIImage?] = [:]
    
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

        activateTapRecognition()
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
    
    func activateTapRecognition() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(AddFoodViewController.didTapView))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapView() {
        searchBar.resignFirstResponder()
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
        let searchBarPlaceholderText = K.searchbarPlaceholder
        var charIndex = 0.0
        for eachLetter in searchBarPlaceholderText{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.07 * charIndex){
                self.searchBar.placeholder?.append(eachLetter)
            }
            charIndex += 1
        }
    }
    
        func displaySearchResults(food: FoodData){
        for eachFood in food.common {
            if !universeOfFood[1].map({ return $0.id }).contains(eachFood.tag_id) {
                let newFood = Food(context: self.context)
                newFood.id = eachFood.tag_id
                newFood.title = eachFood.tag_name
                newFood.isChecked = false
                newFood.imageUrl = eachFood.photo.thumb
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
            }
        } else {
            newIndexpathSection = 0
            if selectedFoods.isEmpty {
                setButtonStatus(toStatus: newButtonStatus)
            }
        }
        universeOfFood[indexPath.section].remove(at: indexPath.row)
        universeOfFood[newIndexpathSection!].insert(usersSelectedCell, at: 0) //move to top of array
        let destinationindexPath = NSIndexPath(row: 0, section: newIndexpathSection!)
        tableView.moveRow(at: indexPath, to: destinationindexPath as IndexPath)
        TJSymptomsBrain.saveContext()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func setButtonStatus (toStatus status: Bool) {
        addFoodButton.isEnabled = status
        addFoodButton.alpha = (addFoodButton.isEnabled ? 1.0 : 0.55)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.275){
            self.foodList.reloadData()
        }
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
        
        // Displays the cell's checkmark when corresponding array.item is checked
        cell.foodCheckmark.isHidden = !(latestFood.isChecked)
        
        cell.imageView?.image = nil
        if let url = URL(string: latestFood.imageUrl!) {
            if let cachedImage = imageCache[url.absoluteString] {
                cell.imageView?.image = cachedImage
            } else {
                foodManager.imageFrom(url: url) {
                    (image, error) in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    
                    // Save the image so we won't have to keep fetching it if they scroll
                    self.imageCache[url.absoluteString] = image
                    
                    if let cellToUpdate = tableView.cellForRow(at: indexPath) {
                        cellToUpdate.imageView?.image = image // will work fine even if image is nil
                        // need to reload the view, which won't happen otherwise
                        // since this is in an async call
                        cellToUpdate.setNeedsLayout()
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return K.foodTableHeaders[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        
        if !(universeOfFood[section].isEmpty) {
            headerView.textLabel?.textColor = UIColor(named: K.BrandColors.blue)
        } else {
            headerView.textLabel?.textColor = UIColor.systemGray
        }
        return headerView
    }
}

//MARK: - UISearchBar Delegate

extension AddFoodViewController: UITextFieldDelegate {
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        resetFoodSearchResults()
        foodList.reloadData()
        searchBar.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
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
