//
//  IconXAxisRendrer.swift
//  AppExtension
//
//  Created by Vaibhav Parmar on 23/03/20.
//  Copyright © 2020 Nickelfox. All rights reserved.
//

import Foundation
import Charts

//swiftlint:disable all
public class IconXAxisRendrer: XAxisRenderer {
    
    var icons: [UIImage]
    
    init(viewPortHandler: ViewPortHandler, xAxis: XAxis?,
         transformer: Transformer?, icons: [UIImage]) {
        
        self.icons = icons
        
        super.init(viewPortHandler: viewPortHandler, xAxis: xAxis, transformer: transformer)
        
    }
 
    public override func drawLabels(context: CGContext, pos: CGFloat, anchor: CGPoint) {
        
        guard let xAxis = self.axis as? XAxis, let transformer = self.transformer else { return }
        
        let paraStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paraStyle.alignment = .center
        
        let labelAttrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: xAxis.labelFont,
                                                          NSAttributedString.Key.foregroundColor: xAxis.labelTextColor,
                                                          NSAttributedString.Key.paragraphStyle: paraStyle]
        
        let FDEG2RAD = CGFloat(Double.pi / 180.0)
        let labelRotationAngleRadians = xAxis.labelRotationAngle * FDEG2RAD
        
        let centeringEnabled = xAxis.isCenterAxisLabelsEnabled
        let valueToPixelMatrix = transformer.valueToPixelMatrix
        
        var position = CGPoint(x: 0.0, y: 0.0)
        
        var labelMaxSize = CGSize()
        
        if xAxis.isWordWrapEnabled {
            labelMaxSize.width = xAxis.wordWrapWidthPercent * valueToPixelMatrix.a
        }
        
        let entries = xAxis.entries
        
        for i in stride(from: 0, to: entries.count, by: 1) {
            if centeringEnabled {
                position.x = CGFloat(xAxis.centeredEntries[i])
            } else {
                position.x = CGFloat(entries[i])
            }
            
            position.y = 0.0
            position = position.applying(valueToPixelMatrix)
            
            if viewPortHandler.isInBoundsX(position.x) {
                let label = xAxis.valueFormatter?.stringForValue(xAxis.entries[i], axis: xAxis) ?? ""
                
                let labelns = label as NSString
                
                if xAxis.isAvoidFirstLastClippingEnabled {
                    // avoid clipping of the last
                    if i == xAxis.entryCount - 1 && xAxis.entryCount > 1 {
                        let width = labelns.boundingRect(with: labelMaxSize, options: .usesLineFragmentOrigin, attributes: labelAttrs, context: nil).size.width
                        
                        if width > (viewPortHandler.offsetRight) * 2.0
                            && position.x + width > viewPortHandler.chartWidth {
                            position.x -= width / 2.0
                        }
                    } else if i == 0 { // avoid clipping of the first
                        let width = labelns.boundingRect(with: labelMaxSize, options: .usesLineFragmentOrigin, attributes: labelAttrs, context: nil).size.width
                        position.x += width / 2.0
                    }
                }
                
                let rawIcon: UIImage = icons[Int(entries[i])].fixedOrientation()
                    .imageRotatedByDegrees(degrees: 180)
                
                let icon: CGImage = rawIcon.cgImage!
                
                // Draw the labels
                drawLabel(context: context, formattedLabel: label, x: position.x, y: pos,
                          attributes: labelAttrs, constrainedToSize: labelMaxSize, anchor: anchor,
                          angleRadians: labelRotationAngleRadians)
                                
                let width = CGFloat(12)
                let point = CGRect(x: position.x - (width / 2),
                                   y: self.viewPortHandler.chartHeight - width * 4,
                                   width: width,
                                   height: width)
                
                // Draw the icons
                context.draw(icon, in: point)
            }
        }
    }
    
    public override func renderGridLines(context: CGContext) {
        super.renderGridLines(context: context)
        self.renderLimitArea(context: context)
    }
    
    public func transformedLimitPositions() -> [CGPoint] {
        guard let xAxis = self.axis as? XAxis,
            let transformer = self.transformer else { return [CGPoint]() }
        
        var positions = [CGPoint]()
        positions.reserveCapacity(xAxis.limitLines.count)
        
        let limitLines = xAxis.limitLines
        
        for i in stride(from: 0,
                        to: xAxis.limitLines.count,
                        by: 1) {
            positions.append(CGPoint(x: 0.0, y: limitLines[i].limit))
        }
        
        transformer.pointValuesToPixel(&positions)
        return positions
    }
    
    public func renderLimitArea(context: CGContext) {
        guard let xAxis = self.axis as? XAxis else { return }
        
        if !xAxis.isEnabled {
            return
        }
        
        if xAxis.limitLines.count > 1 {
            var limitPositions = transformedLimitPositions()
            let viewPortHandler = self.viewPortHandler
            
            var width =  (viewPortHandler.contentBottom) - (viewPortHandler.contentTop)
            if limitPositions.count > 1 {
                width = abs(limitPositions[0].y -  limitPositions[1].y)
            }
            
            context.saveGState()
            defer { context.restoreGState() }
            context.clip(to: self.gridClippingRect)
            context.setShouldAntialias(xAxis.gridAntialiasEnabled)
            context.setStrokeColor(xAxis.gridColor.cgColor)
            context.setLineWidth(xAxis.gridLineWidth)
            context.setLineCap(xAxis.gridLineCap)
            
            if xAxis.gridLineDashLengths != nil {
                context.setLineDash(phase: xAxis.gridLineDashPhase, lengths: xAxis.gridLineDashLengths)
            }
            else {
                context.setLineDash(phase: 0.0, lengths: [])
            }
            
            for i in stride(from: 0, to: limitPositions.count, by: 2) {
                
                let currentColor = getColor(index: i)
                context.setStrokeColor(currentColor)
                context.setLineWidth(width)
                context.beginPath()

                let point1 = CGPoint(x: viewPortHandler.contentLeft, y: (limitPositions[i].y + limitPositions[i+1].y)/2)

//                let point1 = CGPoint(x: 10, y: 50)// + limitPositions[i+1].y)/2)

                context.move(to: point1)

                let point2 = CGPoint(x: viewPortHandler.contentRight, y:  (limitPositions[i].y + limitPositions[i+1].y)/2)

//                let point2 = CGPoint(x: 10, y:  100)// + limitPositions[i+1].y)/2)

                context.addLine(to: point2)

                print("Point 1: \(point1)")
                print("\n Point 2: \(point2)")

                context.strokePath()
            }
        }
    }
    
    func getColor(index : Int) -> CGColor{
        return UIColor.systemOrange.withAlphaComponent(0.5).cgColor
        //        var color:CGColor
        //        if index == 0 {
        //            color = UIColor(hexString: "#2DBE9D").withAlphaComponent(0.2).cgColor
        //        }else {
        //            color = UIColor(hexString: "#6945AC").withAlphaComponent(0.2).cgColor
        //        }
        //        return color
    }
}

extension UIImage {

    public func imageRotatedByDegrees(degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }


    public func fixedOrientation() -> UIImage {
        if imageOrientation == UIImage.Orientation.up {
            return self
        }

        var transform: CGAffineTransform = CGAffineTransform.identity

        switch imageOrientation {
        case UIImageOrientation.down, UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case UIImageOrientation.left, UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi/2)
            break
        case UIImageOrientation.right, UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat.pi/2)
            break
        case UIImageOrientation.up, UIImageOrientation.upMirrored:
            break
        @unknown default:
            break
        }

        switch imageOrientation {
        case UIImageOrientation.upMirrored, UIImageOrientation.downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImageOrientation.leftMirrored, UIImageOrientation.rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up, UIImageOrientation.down, UIImageOrientation.left, UIImageOrientation.right:
            break
        @unknown default:
            break
        }

        let ctx: CGContext = CGContext(data: nil,
                                       width: Int(size.width),
                                       height: Int(size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent,
                                       bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        ctx.concatenate(transform)

        switch imageOrientation {
        case UIImageOrientation.left, UIImageOrientation.leftMirrored, UIImageOrientation.right, UIImageOrientation.rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }

        let cgImage: CGImage = ctx.makeImage()!

        return UIImage(cgImage: cgImage)
    }
}
