//
//  Int+Extenstion.swift
//  Lets Card
//
//  Created by Durgesh on 28/06/23.
//

extension Int {
    func formatPoints() -> String {
        let num = self / 1000000
        let newNum = self / 1000
        var newNumString = "\(self)"
        if num > 1 {
            newNumString = "\(num)m"
        } else if newNum > 1 {
            newNumString = "\(newNum)k"
        }
        
//        if self > 1000 && self < 1000000 {
//            newNumString = "\(newNum)k"
//        } else if self > 1000000 {
//            let num = self / 1000000
//            newNumString = "\(num)m"
//        }
        return newNumString
    }
}
