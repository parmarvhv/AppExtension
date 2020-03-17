//
//  ChartViewController.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 16/03/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import UIKit
import Charts

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
        xAxis.drawGridLinesEnabled = false

        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = 30
        leftAxis.axisMinimum = -1
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
        
        let lhValues = [
            ChartDataEntry(x: 0, y: 0.1),
            ChartDataEntry(x: 1, y: 1.820411016),
            ChartDataEntry(x: 2, y: 0.1),
            ChartDataEntry(x: 3, y: 2.861975264),
            ChartDataEntry(x: 4, y: 4.32281039),
            ChartDataEntry(x: 5, y: 3.92097487),
            ChartDataEntry(x: 6, y: 4.007942457),
            ChartDataEntry(x: 7, y: 5.429096002),
            ChartDataEntry(x: 8, y: 3.970139321),
            ChartDataEntry(x: 9, y: 3.889788656),
            ChartDataEntry(x: 10, y: 2.914878966),
            ChartDataEntry(x: 11, y: 4.940224826),
            ChartDataEntry(x: 12, y: 5.466737925),
            ChartDataEntry(x: 13, y: 5.812275749),
            ChartDataEntry(x: 14, y: 0),
            ChartDataEntry(x: 15, y: 5.967085664),
            ChartDataEntry(x: 16, y: 3.418321836),
            ChartDataEntry(x: 17, y: 5.260091179),
            ChartDataEntry(x: 18, y: 8.364888952),
            ChartDataEntry(x: 19, y: 0),
            ChartDataEntry(x: 20, y: 4.7)
        ]
        let e3gValues = [
            ChartDataEntry(x: 0, y: 22.1000398),
            ChartDataEntry(x: 1, y: 17.35401659),
            ChartDataEntry(x: 2, y: 15.89889207),
            ChartDataEntry(x: 3, y: 7.372342182),
            ChartDataEntry(x: 4, y: 17.41724513)
        ]
        
        let lhSet = LineChartDataSet(entries: lhValues)
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
        
        
        let lhNullSet = LineChartDataSet(entries: lhValues)
        lhNullSet.mode = .cubicBezier
        lhNullSet.cubicIntensity = 0.2
        lhNullSet.axisDependency = .left
        lhNullSet.setColor(.clear)
        lhNullSet.setCircleColor(.clear)
        lhNullSet.circleHoleColor = .clear
        lhNullSet.circleHoleRadius = 3
        lhNullSet.lineWidth = 2
        lhNullSet.circleRadius = 5
        lhNullSet.highlightColor = .clear
        lhNullSet.highlightLineWidth = 1
        lhNullSet.drawCircleHoleEnabled = true
        lhNullSet.drawHorizontalHighlightIndicatorEnabled = false
        
        let e3gSet = LineChartDataSet(entries: e3gValues)
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

        let e3gNullSet = LineChartDataSet(entries: e3gValues)
        e3gNullSet.mode = .cubicBezier
        e3gNullSet.cubicIntensity = 0.2
        e3gNullSet.axisDependency = .left
        e3gNullSet.setColor(.clear)
        e3gNullSet.setCircleColor(.clear)
        e3gNullSet.circleHoleColor = .clear
        e3gNullSet.circleHoleRadius = 3
        e3gNullSet.lineWidth = 2
        e3gNullSet.circleRadius = 5
        e3gNullSet.highlightColor = .clear
        e3gNullSet.highlightLineWidth = 1
        e3gNullSet.drawCircleHoleEnabled = true
        e3gNullSet.drawHorizontalHighlightIndicatorEnabled = false
        
        let data = LineChartData(dataSets: [lhSet, e3gSet])
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
        print(highlight)
    }
    
}

extension ChartViewController: ChartViewDelegate {
    
}
