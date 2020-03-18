//
//  ChartViewController.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 16/03/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import UIKit
import Charts

//swiftlint:disable all
class ChartViewController: UIViewController {

    @IBOutlet var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        self.setDataCount(5, 10)
        self.chartView.setVisibleXRangeMaximum(10)
    }

    private func initialSetup() {
        self.chartView.delegate = self
        self.chartView.chartDescription?.enabled = false
        self.chartView.dragEnabled = true
        self.chartView.setScaleEnabled(false)
        self.chartView.pinchZoomEnabled = false
        self.chartView.legend.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 12)
        xAxis.labelTextColor = .white
        xAxis.drawAxisLineEnabled = false
        xAxis.axisMinimum = -1
        xAxis.drawGridLinesEnabled = false

        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = 30
        leftAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = false
        leftAxis.drawAxisLineEnabled = false

        let rightAxis = chartView.rightAxis
        rightAxis.labelTextColor = .clear
        rightAxis.axisMaximum = 900
        rightAxis.axisMinimum = 0//-200
        rightAxis.granularityEnabled = false
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        
        chartView.animate(xAxisDuration: 1.0)
    }
    
    func setDataCount(_ count: Int, _ range: UInt32) {
        
        var chartDataSets: [LineChartDataSet] = []
        var lhDataEntries: [[ChartDataEntry]] = []
        var e3gDataEntries: [[ChartDataEntry]] = []
        
        let lhRawValues: [Double?] = [nil, nil, nil, nil, nil, 0, 1.820411016, 0, 2.861975264,
                                      4.32281039, 3.92097487, 4.007942457, 5.429096002, 3.970139321,
                                      3.889788656, 2.914878966, 4.940224826, 5.466737925, 5.812275749,
                                      nil, 5.967085664, 3.418321836, 5.260091179, 8.364888952, nil, 4.7,
                                      4.4, 5.7, 5.4, 4.2, nil, 6.4, nil, nil, nil, nil, 4.6, 4.4, nil, nil,
                                      nil, nil, nil, nil, nil, nil, nil, nil
        ]
        
        let e3gRawValues: [Double?] = [
            nil,
            nil,
            nil,
            nil,
            nil,
            22.1000398,
            17.35401659,
            15.89889207,
            7.372342182,
            17.41724513,
            10.54070366,
            9.177579107,
            19.14365766,
            7.112468003,
            8.718191366,
            6.036283861,
            9.961434688,
            14.3813456,
            12.41902923,
            nil,
            11.65332028,
            14.9029937,
            13.49255279,
            14.88897989,
            nil,
            11.3,
            18.2,
            20,
            11.1,
            15.5,
            nil,
            15.9,
            nil,
            nil,
            nil,
            nil,
            9.5,
            16,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil
        ]
        
        
        func calculateLHDataSets() {
            var lhDataEntryList: [ChartDataEntry] = []
            let _ = (0..<lhRawValues.count).map { xAxis in
                if lhRawValues[xAxis] == nil {
                    if lhDataEntryList.isEmpty { return }
                    lhDataEntries.append(lhDataEntryList)
                    lhDataEntryList = []
                } else {
                    lhDataEntryList.append(ChartDataEntry(x: Double(xAxis), y: lhRawValues[xAxis]!))
                }
            }
        }
        
        func calculateE3GDataSets() {
            var e3gDataEntryList: [ChartDataEntry] = []
            let _ = (0..<e3gRawValues.count).map { xAxis in
                if e3gRawValues[xAxis] == nil {
                    if e3gDataEntryList.isEmpty { return }
                    e3gDataEntries.append(e3gDataEntryList)
                    e3gDataEntryList = []
                } else {
                    e3gDataEntryList.append(ChartDataEntry(x: Double(xAxis), y: e3gRawValues[xAxis]!))
                }
            }
        }
        
        calculateLHDataSets()
        calculateE3GDataSets()
        
        for lhDataEntry in lhDataEntries {
            let lhSet = LineChartDataSet(entries: lhDataEntry)
            lhSet.mode = .cubicBezier
            lhSet.cubicIntensity = 0.2
            lhSet.axisDependency = .left
            lhSet.setColor(UIColor(hexString: "1989BC"))
            lhSet.setCircleColor(.white)
            lhSet.circleHoleColor = UIColor(hexString: "1989BC")
            lhSet.circleHoleRadius = 3
            lhSet.lineWidth = 2
            lhSet.circleRadius = 5
            lhSet.highlightColor = UIColor(hexString: "112D35")
            lhSet.highlightLineWidth = 1
            lhSet.drawCircleHoleEnabled = true
            lhSet.drawHorizontalHighlightIndicatorEnabled = false
            chartDataSets.append(lhSet)
        }
        
        for e3gDataEntry in e3gDataEntries {
            let e3gSet = LineChartDataSet(entries: e3gDataEntry)
            e3gSet.mode = .cubicBezier
            e3gSet.cubicIntensity = 0.2
            e3gSet.axisDependency = .left
            e3gSet.setColor(UIColor(hexString: "8828E2"))
            e3gSet.setCircleColor(.white)
            e3gSet.circleHoleColor = UIColor(hexString: "8828E2")
            e3gSet.circleHoleRadius = 3
            e3gSet.lineWidth = 2
            e3gSet.circleRadius = 5
            e3gSet.highlightColor = UIColor(hexString: "112D35")
            e3gSet.highlightLineWidth = 1
            e3gSet.drawCircleHoleEnabled = true
            e3gSet.drawHorizontalHighlightIndicatorEnabled = false
            chartDataSets.append(e3gSet)
        }
        
        let data = LineChartData(dataSets: chartDataSets)
        data.setValueTextColor(.clear)
        data.setValueFont(.systemFont(ofSize: 9))
        
        self.chartView.data = data
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        self.chartView.centerViewToAnimated(xValue: entry.x,
                                            yValue: entry.y,
                                            axis: self.chartView.data!
                                                .getDataSetByIndex(highlight.dataSetIndex).axisDependency,
                                            duration: 1)
    }
    
}

extension ChartViewController: ChartViewDelegate {
    
}
