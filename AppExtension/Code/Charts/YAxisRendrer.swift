//
//  YAxisRendrer.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 23/03/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import Foundation
import Charts

//swiftlint:disable all
/*
class YaxisRendrer: YAxisRenderer {
    
    var maxHartslag: Double!
    
    override func renderGridLines(context: CGContext) {
        
        guard let yAxis = self.axis as? YAxis, yAxis.isEnabled else { return }
        
        //if !yAxis.isEnabled { return }
        
        if yAxis.drawGridLinesEnabled {
            
            var positions = transformedPositions()
            let viewPortHandler = self.viewPortHandler
            var width =  viewPortHandler.contentBottom - viewPortHandler.contentTop
            
            if positions.count > 1 {
                width = abs(positions[0].y -  positions[1].y)
            }
            
            context.saveGState()
            
            defer { context.restoreGState() }
            
            context.clip(to: self.gridClippingRect)
            
            context.setShouldAntialias(yAxis.gridAntialiasEnabled)
            context.setStrokeColor(yAxis.gridColor.cgColor)
            context.setLineWidth(yAxis.gridLineWidth)
            context.setLineCap(yAxis.gridLineCap)
            
            
            if yAxis.gridLineDashLengths != nil {
                context.setLineDash(phase: yAxis.gridLineDashPhase,
                                    lengths: yAxis.gridLineDashLengths)
            } else {
                context.setLineDash(phase: 0.0, lengths: [])
            }
            
            print("----------------------")
            
            for i in 0 ..< positions.count {
                let currentColor = getColor(y: Int(positions[i].y))
                context.setStrokeColor(currentColor)
                context.setLineWidth(width)
                context.beginPath()
                context.move(to: CGPoint(x: viewPortHandler.contentLeft, y: positions[i].y))
                context.addLine(to: CGPoint(x: viewPortHandler.contentRight, y:  positions[i].y))
                context.strokePath()
            }
            print("----------------------")
            print("\n")
        }
        
        if yAxis.drawZeroLineEnabled {
            drawZeroLine(context: context)
        }
        
    }
    
    func getColor(y : Int) -> CGColor{
        let maxZone = Int(Double(maxHartslag / 100 * 45))
        let zwaarZone = Int(Double(maxHartslag / 100 * 36))
        let gemZone = Int(Double(maxHartslag / 100 * 34))
        let lichtZone = Int(Double(maxHartslag / 100 * 32))
        let zLichtZone = Int(Double(maxHartslag / 100 * 30))
        
        if y >= maxZone{
            print("\(y) ->  rood")
            return UIColor.init(red: 255, green: 40/255, blue: 60/255, alpha: 1).cgColor
        }
        else if y >= zwaarZone && y < maxZone{
            print("\(y) ->  geel")
            return UIColor.init(red: 240/255, green: 169/255, blue: 31/255, alpha: 1).cgColor
        }
        else if y >= gemZone && y < zwaarZone{
            print("\(y) ->  groen")
            return UIColor.init(red: 42/255, green:159/255, blue: 85/255, alpha: 1).cgColor
        }
        else if y >= lichtZone && y < gemZone{
            print("\(y) ->  blauw")
            return UIColor.init(red: 67/255, green: 153/255, blue: 212/255, alpha: 1).cgColor
        }
        else if y >= zLichtZone && y < lichtZone{
            print("\(y) ->  grijs")
            return UIColor.init(red: 159/255, green: 170/255, blue: 170/255, alpha: 1).cgColor
        }
        else if y > 0 && y < zLichtZone{
            print("\(y) ->  grijs")
            return UIColor.init(red: 159/255, green: 170/255, blue: 170/255, alpha: 1).cgColor
        }
        else{
            print("\(y) ->  grijs")
            return UIColor.init(red: 159/255, green: 170/255, blue: 170/255, alpha: 1).cgColor
        }
    }
    
}
*/

public class ChartYAxisArea: YAxisRenderer {
    
    public override func renderGridLines(context: CGContext) {
           super.renderGridLines(context: context)
           
           renderLimitArea(context: context)
    }
    
    public func transformedLimitPositions() -> [CGPoint] {
        guard
            let yAxis = self.axis as? YAxis,
            let transformer = self.transformer
            else { return [CGPoint]() }
        
        var positions = [CGPoint]()
        positions.reserveCapacity(yAxis.limitLines.count)
        
    
        let limitLines = yAxis.limitLines

        for i in stride(from: 0, to: yAxis.limitLines.count, by: 1)
        {
            positions.append(CGPoint(x: 0.0, y: limitLines[i].limit))
        }
        
        transformer.pointValuesToPixel(&positions)
        
        return positions
    }
    
    public func renderLimitArea(context: CGContext) {
        guard let
            yAxis = self.axis as? YAxis
            else { return }
        
        if !yAxis.isEnabled {
            return
        }
        if yAxis.limitLines.count > 1 {
            var limitPositions = transformedLimitPositions()
            
            let viewPortHandler = self.viewPortHandler
           
            var width =  (viewPortHandler.contentBottom) - (viewPortHandler.contentTop)
            if limitPositions.count > 1 {
                width = abs(limitPositions[0].y -  limitPositions[1].y)
            }
            
            context.saveGState()
            defer { context.restoreGState() }
            context.clip(to: self.gridClippingRect)
            

            context.setShouldAntialias(yAxis.gridAntialiasEnabled)
            context.setStrokeColor(yAxis.gridColor.cgColor)
            context.setLineWidth(yAxis.gridLineWidth)
            context.setLineCap(yAxis.gridLineCap)
            
            if yAxis.gridLineDashLengths != nil {
                context.setLineDash(phase: yAxis.gridLineDashPhase, lengths: yAxis.gridLineDashLengths)
            }
            else {
                context.setLineDash(phase: 0.0, lengths: [])
            }
            
            
            for i in stride(from: 0, to: limitPositions.count, by: 2){
                let currentColor = getColor(index: i)
                context.setStrokeColor(currentColor)
                context.setLineWidth(width)
                context.beginPath()
                //let p1 = CGPoint(x: viewPortHandler.contentLeft, y: (limitPositions[i].y + limitPositions[i+1].y)/2)
                let p1 = CGPoint(x: viewPortHandler.contentTop, y: limitPositions[i].y)// + limitPositions[i+1].y)/2)
                print("P1: \(p1)")
                context.move(to: p1)
                
                //let p2 = CGPoint(x: viewPortHandler.contentRight, y:  (limitPositions[i].y + limitPositions[i+1].y)/2)
                let p2 = CGPoint(x: viewPortHandler.contentBottom, y:  limitPositions[i].y)
                print("P2: \(p2)")
                context.addLine(to: p2)
                context.strokePath()
            }
        }
    }
    
    func getColor(index : Int) -> CGColor{
        return UIColor.systemPink.withAlphaComponent(0.5).cgColor
//        var color:CGColor
//        if index == 0 {
//            color = UIColor(hexString: "#2DBE9D").withAlphaComponent(0.2).cgColor
//        }else {
//            color = UIColor(hexString: "#6945AC").withAlphaComponent(0.2).cgColor
//        }
//        return color
    }
    
}
