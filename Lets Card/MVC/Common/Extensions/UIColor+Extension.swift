//
//  UIColor+Extension.swift
//  Lets Card
//
//  Created by Durgesh on 15/12/22.
//

import UIKit

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexint = Int(Self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    static private func intFromHexString(hexStr: String) -> UInt64 {
        var hexInt: UInt64 = 0
        let scanner: Scanner = Scanner(string: hexStr)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt64(&hexInt)
        return hexInt
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: 1)
    }
    
    static var loginYellow: UIColor {
        return UIColor(hexString: "#e19303")
    }
    
    static var goldenYellow: UIColor {
        return UIColor(hexString: "#FFDF00")
    }
    
    static var headerColor: UIColor {
        return UIColor(hexString: "#eac127")
    }
}
