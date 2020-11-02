//
//  AddFoodViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import RealmSwift

class AddFoodViewController: UIViewController, UITableViewDelegate{
   
   let realm = try! Realm()
   
   var universeOfFood: [Results<Food>] {
      get {
         let checkedItemsPredicate = NSPredicate(format: "isChecked == true", argumentArray: nil)
         let uncheckedItemsPredicate = NSPredicate(format: "isChecked == false", argumentArray: nil)
         let checkedItems = realm.objects(Food.self).filter(checkedItemsPredicate)
         let uncheckedItems = realm.objects(Food.self).filter(uncheckedItemsPredicate)
//         print ("universeOfFood is set")
         return [checkedItems,uncheckedItems]
      }
//      set {
//         foodList.reloadData()
//      }
   }
   var foodManager = FoodManager()
//   var foodString = ""
   
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
      
//      universeOfFood = TJSymptomsBrain.loadFoods()
      resetUsersSearchResults()
      resetUsersSelectedFoods()
      searchBar.becomeFirstResponder()
      
      activateTapRecognition()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = true
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = false
   }
   
   override func viewDidAppear(_ animated: Bool) {
      displaySearchbarAnimation()
   }
   
   @IBAction func backButtonPressed(_ sender: Any) {
      navigationController?.popToRootViewController(animated: true)
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
         let listOfSelectedFoods = universeOfFood[0].map({$0.title})
         let destinationVC = segue.destination as! CompleteEntryViewController
         
         destinationVC.selectedFoods = universeOfFood
         resetUsersSearchResults()
         resetUsersSelectedFoods()
      }
   }
   
   //    This block animates the Searchbar Placeholder text
   func displaySearchbarAnimation() {
      searchBar.placeholder = ""
      let searchBarPlaceholderText = K.searchbarPlaceholder
      var charIndex = 0.0
      for eachLetter in K.searchbarDefaultText {
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.07 * charIndex){
            self.searchBar.placeholder?.append(eachLetter)
         }
         charIndex += 1
      }
   }
   
   func displaySearchResults(food: FoodData){
      for eachFood in food.common {
         if !universeOfFood[1].map({ return $0.id }).contains(eachFood.tag_id) {
            let newFood = Food()
            newFood.id = eachFood.tag_id
            newFood.title = eachFood.tag_name
//            newFood.isChecked = false
            newFood.imageUrl = eachFood.photo.thumb
            TJSymptomsBrain.saveFoods(food: newFood)
         }
      }
//      TJSymptomsBrain.saveContext()
      foodList.reloadData()
   }
   
   func resetUsersSelectedFoods(){
      let selectedFoods = universeOfFood[0]
      
      if selectedFoods.count > 0 {
//         var foodItemCount = selectedFoods.count - 1
         for eachFoodItem in selectedFoods {
//            TJSymptomsBrain.context.delete(eachFoodItem)
            TJSymptomsBrain.deleteFoods(food: eachFoodItem)
//            universeOfFood[0].remove(at: foodItemCount)
//            foodItemCount -= 1
         }
//         TJSymptomsBrain.saveContext()
      }
   }
   
   func resetUsersSearchResults(){
      let commonFoods = universeOfFood[1]
      
      if commonFoods.count > 0 {
//         var foodItemCount = commonFoods.count - 1
         for eachFoodItem in commonFoods {
//            TJSymptomsBrain.context.delete(eachFoodItem)
            TJSymptomsBrain.deleteFoods(food: eachFoodItem)
//            universeOfFood[1].remove(at: foodItemCount)
//            foodItemCount -= 1
         }
//         TJSymptomsBrain.saveContext()
      }
   }
   
   //MARK: - TableView Delegate Methods
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let usersSelectedFoods = universeOfFood[0]
      let newIndexPath: IndexPath?
      if indexPath.section == 0 {
         newIndexPath = [1, 0]
         if usersSelectedFoods.count == 1 {
            addFoodButton.deactivateButton()
         }
      } else {
         newIndexPath = [0, universeOfFood[0].count]
         if usersSelectedFoods.isEmpty {
            addFoodButton.activateButton()
         }
      }

      let usersSelectedCell = universeOfFood[indexPath.section][indexPath.row]
      try! realm.write{
         usersSelectedCell.isChecked = !usersSelectedCell.isChecked
      }
      guard let cell = tableView.cellForRow(at: indexPath) as? FoodCell else {return}
      cell.foodCheckmark.isHidden = !(usersSelectedCell.isChecked)
      
      tableView.deselectRow(at: indexPath, animated: true)
      tableView.moveRow(at: indexPath, to: newIndexPath ?? [0, 0])
   }
   
   func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
      searchBar.resignFirstResponder()
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
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 100.0
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: K.foodCellIdentifier, for: indexPath) as! FoodCell
      let latestFood = universeOfFood[indexPath.section][indexPath.row]
      
      cell.foodLabel?.text = latestFood.title
      
      // Displays the cell's checkmark when corresponding array.item is checked
      cell.foodCheckmark.isHidden = !(latestFood.isChecked)
      
      if let foodImageUrl = URL(string: latestFood.imageUrl) {
         foodManager.imageFrom(url: foodImageUrl) {
            (image, error) in
            guard error == nil else {
               print("There was an error getting the image: \(error!)")
               return
            }
            
            cell.foodImage?.image = image // will work fine even if image is nil
            // need to reload the view, which won't happen otherwise, since this is in an async call
            
            cell.setNeedsLayout()
         }
      }
      return cell
   }
   
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 14))
      headerView.backgroundColor = .white
      let headerLabel = UILabel()
      headerView.addSubview(headerLabel)
      headerLabel.translatesAutoresizingMaskIntoConstraints = false
      headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
      headerLabel.leadingAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
      headerLabel.font = .boldSystemFont(ofSize: 17)
      headerLabel.text = K.foodTableHeaders[section]
      headerLabel.textColor = UIColor(named: K.BrandColors.blue)

      return headerView
   }
}

//MARK: - UISearchBar Delegate

extension AddFoodViewController: UITextFieldDelegate {
   
   func textFieldShouldClear(_ textField: UITextField) -> Bool {
      resetUsersSearchResults()
      foodList.reloadData()
      searchBar.resignFirstResponder()
      return true
   }
   
//   func textFieldDidEndEditing(_ textField: UITextField) {
//   }
   
   func textFieldDidChangeSelection(_ textField: UITextField) {
      if let foodItem = searchBar.text {
         if foodItem.count >= 3 {
            foodManager.fetchFoods(foodItem)
         } else if foodItem.count == 0 {
            resetUsersSearchResults()
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
            if foodItem.count >= 3 {
               self.resetUsersSearchResults()
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
