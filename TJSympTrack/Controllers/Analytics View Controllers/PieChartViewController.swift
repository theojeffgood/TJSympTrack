//
//  AnalyticsViewController.swift
//  TJSympTrack
//
//  Created by Theo Goodman on 4/15/20.
//  Copyright © 2020 Theo Goodman. All rights reserved.
//

import UIKit
import Firebase
import Charts

class PieChartViewController: UIViewController {
   
   @IBOutlet weak var symptomInFocus: UILabel!
   @IBOutlet weak var pieChart: PieChartView!
   
   var loadFoodDataFromGoogle = LoadFoodDataFromGoogle()
   var selectedSymptom: String?
   var relevantFoods: [String: Int] = [:]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      symptomInFocus.text = selectedSymptom ?? "No Symptom Was Selected"
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
   }
   
   @IBAction func closeAnalyticsButtonPressed(_ sender: UIButton) {
      navigationController?.popToRootViewController(animated: true)
   }
   
   func refreshChart(usingRefreshedData chartDataSet: PieChartDataSet) {
      let chartData = PieChartData(dataSet: chartDataSet)
      
      let pFormatter = NumberFormatter()
      pFormatter.numberStyle = .percent
      pFormatter.maximumFractionDigits = 1
      pFormatter.multiplier = 1
      pFormatter.percentSymbol = "%"
      chartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
      
      pieChart.animate(xAxisDuration: 1.1, easingOption: .easeOutBack)
      pieChart.animate(yAxisDuration: 1.1)
      pieChart.drawEntryLabelsEnabled = false
      pieChart.legend.font = UIFont(name: "Futura", size: 25)!
      pieChart.legend.formSize = 15
      pieChart.legend.drawInside = false
      pieChart.data = chartData
   }
   
   func populateChartDataSet(){
      var numberOfDownloadsDataEntries = [PieChartDataEntry]()
      for (key, value) in relevantFoods{
         let latestChartDataPoint = PieChartDataEntry(value: Double(value), label: key)
         numberOfDownloadsDataEntries.append(latestChartDataPoint)
      }
      
      let chartDataSet = PieChartDataSet(entries: numberOfDownloadsDataEntries, label: nil)
      chartDataSet.colors = ChartColorTemplates.joyful()
      chartDataSet.sliceSpace = 7
      chartDataSet.entryLabelFont = UIFont(name: "Futura", size: 20)!
      chartDataSet.entryLabelColor = .black
      chartDataSet.valueColors = [.black]
      chartDataSet.valueFont = UIFont(name: "Futura", size: 15.0)!
      refreshChart(usingRefreshedData: chartDataSet)
   }
}

extension PieChartViewController: LoadFoodDataFromGoogleDelegate {
   func didRetrieveFoodData(foodsData: [String: Int]) {
      relevantFoods = foodsData
      populateChartDataSet()
   }
   
   func didFailWithError(error: Error) {
      print ("There was an error retrieving data from the Google Cloud: \(error)")
   }
   
   
}
