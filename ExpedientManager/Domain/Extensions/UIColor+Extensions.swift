//
//  Extension+UIColor.swift
//  ExpedientManager
//
//  Created by Gonzalo Ivan Santos Portales on 22/11/24.
//

import UIKit

extension UIColor {
    private func float2String(_ float : CGFloat) -> String {
        return String(format:"%02X", Int(round(float * 255)))
    }

    var hex : String {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return "#" + float2String(red) + float2String(green) + float2String(blue)
    }

    convenience init(hex : String) {
        let hex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        if hex.count == 6, hex.range(of: "[^0-9A-Fa-f]", options: .regularExpression) == nil {
            let chars = Array(hex)
            let numbers = stride(from: 0, to: chars.count, by: 2).map() {
                CGFloat(strtoul(String(chars[$0 ..< min($0 + 2, chars.count)]), nil, 16))
            }
            self.init(red: numbers[0] / 255, green: numbers[1] / 255, blue: numbers[2] / 255, alpha: 1.0)
        } else {
            self.init(white: 1.0, alpha: 1.0)
        }
    }
}
