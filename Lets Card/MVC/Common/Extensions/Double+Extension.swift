//
//  Double+Extension.swift
//  Lets Card
//
//  Created by Durgesh on 21/12/22.
//

extension Double {
    /* Return clean double decimal value */
    var cleanValuee: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.1f", self) : String(format: "%.1f", self)
    }
    
    var cleanValue2: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", self) : String(format: "%.2f", self)
    }
    
    var cleanValue0: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.0f", self)
    }

    func cleanValue(_ decimalPlaces: inout Int) -> String {
        if decimalPlaces <= 0 {
            decimalPlaces = 1
        }
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.\(decimalPlaces)f", self) : String(format: "%.\(decimalPlaces)f", self)
    }
    
}
