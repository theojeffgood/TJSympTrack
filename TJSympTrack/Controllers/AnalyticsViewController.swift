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

class AnalyticsViewController: UIViewController {
    
    @IBOutlet weak var symptomInFocus: UILabel!
    @IBOutlet weak var pieChart: PieChartView!
    var iosDataEntry = PieChartDataEntry(value: 0.0)
    var macDataEntry = PieChartDataEntry(value: 0.0)
    
    var numberOfDownloadsDataEntries = [PieChartDataEntry]()
    
    var relevantFoods: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.chartDescription?.text = "Tester"
        
//        iosDataEntry.value = 15.0
//        iosDataEntry.label = "iOS"
//
//        macDataEntry.value = 20.0
//        macDataEntry.label = "macOS"
        
//        numberOfDownloadsDataEntries = [iosDataEntry, macDataEntry]
//        refreshChart()
    }
    
    func refreshChart(usingRefreshedData chartDataSet: PieChartDataSet, usingColors colors: [NSUIColor]) {
        let chartData = PieChartData(dataSet: chartDataSet)
        
        chartDataSet.colors = colors
        pieChart.data = chartData
    }
    
    func populateChartDataSet(forFoods foodsList: [String]){
        var colors = [UIColor(named: K.BrandColors.blue), UIColor(named: K.BrandColors.gray)]
        for eachFood in foodsList {
            let latestChartDataPoint = PieChartDataEntry()
            latestChartDataPoint.label = eachFood
            latestChartDataPoint.value = 0.0
            numberOfDownloadsDataEntries.append(latestChartDataPoint)
            
            // REAL COLOR-GEN LOGIC NEEDED
            let newColor = NSUIColor()
            colors.append(newColor)
        }
        
        let chartDataSet = PieChartDataSet(entries: numberOfDownloadsDataEntries, label: nil)
        refreshChart(usingRefreshedData: chartDataSet, usingColors: colors as! [NSUIColor])
    }
}
