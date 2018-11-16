//
//  AdvancedVC.swift
//  RGB
//
//  Created by Brenno Ribeiro on 9/20/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import UIKit
import Charts

enum histMode {
    case RGB
    case Red
    case Green
    case Blue
    case Intensity
}

class AdvancedVC: UIViewController {
    
    // IB Outlets
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var statsLblLeft: UILabel!
    @IBOutlet weak var forwardHistBtn: UIButton!
    @IBOutlet weak var backHistBtn: UIButton!
    @IBOutlet weak var histModeLbl: UILabel!
    @IBOutlet weak var statsLblRight: UILabel!
    
    var histModeState: histMode = .RGB
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backHistBtn.isHidden = true
        // Do any additional setup after loading the view.
        initChartData(red: RH, green: GH, blue: BH)
    }
    
    func initChartData(red: [Float], green: [Float], blue: [Float]) {
        
        var dataX = Array(1...256)
        var dataR = [Int]()
        var dataG = [Int]()
        var dataB = [Int]()
        
        for i in 0...255 {
            let tempR = red.filter{Int($0) == i}.count
            dataR.append(tempR)
            let tempG = green.filter{Int($0) == i}.count
            dataG.append(tempG)
            let tempB = blue.filter{Int($0) == i}.count
            dataB.append(tempB)
        }
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0...255 {
            let dataEntryR = BarChartDataEntry(x: Double(dataX[i]), y: Double(dataR[i]))
            dataEntries.append(dataEntryR)
            let dataEntryG = BarChartDataEntry(x: Double(dataX[i]), y: Double(dataG[i]))
            dataEntries.append(dataEntryG)
            let dataEntryB = BarChartDataEntry(x: Double(dataX[i]), y: Double(dataB[i]))
            dataEntries.append(dataEntryB)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "au")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        barChartView.xAxis.labelPosition = .bottom
        barChartView.leftAxis.axisMinimum = 0
        barChartView.rightAxis.axisMinimum = 0
        barChartView.legend.enabled = false
        barChartView.animate(yAxisDuration: 2)
        
        switch histModeState {
        case .Intensity:
            chartDataSet.colors = [.gray]
        default:
            chartDataSet.colors = [.red, .green, .blue]
        }
    }
    
    func initializeStats(hist: [Float]) {
        let min = hist.min()
        let max = hist.max()
        let count = hist.count
        let avg = hist.reduce(0, +) / Float(count)
        let variance = hist.reduce(0, { $0 + ($1-avg)*($1-avg) })
        let stdev = sqrt(variance)
        let median = hist.sorted(by: <)[count / 2]
        statsLblLeft.text = NSString(format: """
            Mean: %.3f
            Median: \(median)
            StDev: %.3f
            """
            as NSString, avg, stdev) as String
        statsLblRight.text = """
            Count: \(count)
            Min: \(min!)
            Max: \(max!)
            """
    }
    
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func forwardHistBtnWasPressed(_ sender: Any) {
        print(histModeState)
        switch histModeState {
        case .RGB:
            initChartData(red: RH, green: [], blue: [])
            initializeStats(hist: RH)
            histModeState = .Red
            backHistBtn.isHidden = false
        case .Red:
            initChartData(red: [], green: GH, blue: [])
            initializeStats(hist: GH)
            histModeState = .Green
        case .Green:
            initChartData(red: [], green: [], blue: BH)
            initializeStats(hist: BH)
            histModeState = .Blue
        case .Blue:
            histModeState = .Intensity
            initChartData(red: [], green: IH, blue: [])
            initializeStats(hist: IH)
            forwardHistBtn.isHidden = true
        case .Intensity:
            forwardHistBtn.isHidden = true
        }
        histModeLbl.text = "\(histModeState) Histogram"
    }
    
    @IBAction func backHistBtnWasPressed(_ sender: Any) {
        print(histModeState)
        switch histModeState {
        case .RGB:
            backHistBtn.isHidden = true
        case .Red:
            initChartData(red: RH, green: GH, blue: BH)
            histModeState = .RGB
            backHistBtn.isHidden = true
        case .Green:
            initChartData(red: RH, green: [], blue: [])
            initializeStats(hist: RH)
            histModeState = .Red
        case .Blue:
            initChartData(red: [], green: GH, blue: [])
            initializeStats(hist: GH)
            histModeState = .Green
        case .Intensity:
            histModeState = .Blue
            initChartData(red: [], green: [], blue: BH)
            initializeStats(hist: BH)
            forwardHistBtn.isHidden = false
        }
        histModeLbl.text = "\(histModeState) Histogram"
    }
    
    
    
}
