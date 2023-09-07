

import Foundation
import SwiftUI

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
    var hexNumber: UInt64 = 0
    guard scanner.scanHexInt64(&hexNumber) else {
      self.init(red: 0, green: 0, blue: 0)
      return
    }
    let red = Double((hexNumber & 0xff0000) >> 16) / 255.0
    let green = Double((hexNumber & 0x00ff00) >> 8) / 255.0
    let blue = Double(hexNumber & 0x0000ff) / 255.0
    self.init(red: red, green: green, blue: blue)
  }
  
  func toHex() -> String {
    let uiColor = UIColor(self).resolvedColor(with: .current)
    
    guard let components = uiColor.cgColor.components, components.count >= 3 else {
      return ""
    }
    
    let r = Float(components[0])
    let g = Float(components[1])
    let b = Float(components[2])
    
    let hexString = String(format: "#%02X%02X%02X", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    return hexString
  }
  
  static let primaryColor = Color(hex: "F4D0D0")
  static let darkPrimary = Color(hex: "ECA4A4")
  static let homeActionColor = Color(hex: "ECA4A4")
//  7A3E3E
//  Darker Shade 1: ECA4A4
//  Darker Shade 2: E27777
//  Darker Shade 3: D54F4F
//  Darker Shade 4: C82626
//  Darker Shade 5: BA0000

}
