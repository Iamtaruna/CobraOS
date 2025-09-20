//
//  Color+Extension.swift
//  Cobra
//
//  Created by Taruna Singh on 3/16/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        var hexSanitized = hex.replacingOccurrences(of: "#", with: "")
        
        if hexSanitized.count == 6 {  // Make sure the length is valid
            hexSanitized = "FF\(hexSanitized)" // Add FF for alpha channel if it's missing
        }
        
        // Convert the hex string to a number
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        let a = Double((rgb & 0xFF000000) >> 24) / 255.0
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

