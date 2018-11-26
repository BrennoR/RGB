//
//  RGB.swift
//  Colorimetry
//
//  Created by Brenno Ribeiro on 2/15/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import Foundation
import UIKit

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

extension UIImage {
    func getPixelColor(pos: CGPoint) -> String {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        print(pixelInfo)
        let r = CGFloat(data[pixelInfo])
        let g = CGFloat(data[pixelInfo+1])
        let b = CGFloat(data[pixelInfo+2])
//        let a = CGFloat(data[pixelInfo+3])
        
        let value = "r: \(r), g: \(g), b: \(b)"
        return value
    }
    
    func getAvgPixelColor(pos: CGPoint) -> String {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        var counter = 0
        var R = 0
        var G = 0
        var B = 0
        
        for i in 0...Int(self.size.width - 1) {
            for j in 0...Int(self.size.height - 1) {
                let point = CGPoint(x: i, y: j)
                let pixelInfo = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
                let r = CGFloat(data[pixelInfo])
                let g = CGFloat(data[pixelInfo+1])
                let b = CGFloat(data[pixelInfo+2])
                counter += 1
                R += Int(r)
                G += Int(g)
                B += Int(b)
                print(counter)
                print(b)
                print(B)
            }
        }
        
        let avgR = R / counter
        //        print(avgR)
        let avgG = G / counter
        //        print(avgG)
        let avgB = B / counter
        //        print(avgB)
        
        let value = "r: \(avgR), g: \(avgG), b: \(avgB)"
        return value
    }
    
    func getAvgPixelColorFromBox(box: UILabel) -> RGBValues {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        var counter: Float = 0
        var R: Float = 0
        var G: Float = 0
        var B: Float = 0
        let pos = box.frame.origin
        let width = box.frame.size.width
        let height = box.frame.size.height
        print(pos)
        print(width)
        print(height)
        
        var RH: [Float] = []
        var BH: [Float] = []
        var GH: [Float] = []
        var IH: [Float] = []
        
        for i in Int(pos.x + 1)...Int(pos.x + width - 1) {
            for j in Int(pos.y + 1)...Int(pos.y + height - 1) {
                let point = CGPoint(x: i, y: j)
                let pixelInfo = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
                let r = CGFloat(data[pixelInfo])
                RH.append(Float(r))
                let g = CGFloat(data[pixelInfo+1])
                GH.append(Float(g))
                let b = CGFloat(data[pixelInfo+2])
                BH.append(Float(b))
                let intensity = 0.299*r + 0.587*g + 0.114*b
                IH.append(Float(intensity))
                counter += 1
                R += Float(r)
                G += Float(g)
                B += Float(b)
                //                print(counter)
            }
        }
        
        let avgR = R / counter
        //        print(avgR)
        let avgG = G / counter
        //        print(avgG)
        let avgB = B / counter
        //        print(avgB)
        
//        return (avgR, avgG, avgB, RH, GH, BH, IH)
        return RGBValues(red: avgR, green: avgG, blue: avgB, rh: RH, gh: GH, bh: BH, ih: IH)
    }
    
    func makeColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    

    func getAvgPixelColorFromCircle(box: UILabel) -> RGBValues {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        var counter: Float = 0
        var R: Float = 0
        var G: Float = 0
        var B: Float = 0
        let pos = box.frame.origin
        let width = box.frame.size.width
        let height = box.frame.size.height
        let radius = Int(width / 2)
        print(pos)
        print(width)
        print(height)
        
        var RH: [Float] = []
        var BH: [Float] = []
        var GH: [Float] = []
        var IH: [Float] = []
        
        for j in Int(pos.y + 1)...Int(pos.y + height - 1) {
            var cFunc = sqrt(Double(radius^^2 - (334 - j)^^2))
            if cFunc.isNaN == true {
                cFunc = 0
            }
            print(j)
            print(cFunc)
            for i in Int(pos.x) + radius - Int(cFunc)...Int(pos.x) + radius + Int(cFunc) {
                let point = CGPoint(x: i, y: j)
                let pixelInfo = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
                let r = CGFloat(data[pixelInfo])
                RH.append(Float(r))
                let g = CGFloat(data[pixelInfo+1])
                GH.append(Float(g))
                let b = CGFloat(data[pixelInfo+2])
                BH.append(Float(b))
                let intensity = 0.299*r + 0.587*g + 0.114*b
                IH.append(Float(intensity))
                counter += 1
                R += Float(r)
                G += Float(g)
                B += Float(b)
                //                print(counter)
            }
        }
        
        let avgR = R / counter
        //        print(avgR)
        let avgG = G / counter
        //        print(avgG)
        let avgB = B / counter
        //        print(avgB)
        
//        return (avgR, avgG, avgB, RH, GH, BH, IH)
        return RGBValues(red: avgR, green: avgG, blue: avgB, rh: RH, gh: GH, bh: BH, ih: IH)
    }
    
    
}
