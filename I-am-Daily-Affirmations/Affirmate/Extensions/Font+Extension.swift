

import Foundation
import SwiftUI
extension Font {
  static func font(_ design: String, style: Font.TextStyle) -> Font {
      switch design.lowercased() {
      case "default":
          return Font.system(style, design: .default)
      case "serif":
          return Font.system(style, design: .serif)
      case "rounded":
          return Font.system(style, design: .rounded)
      case "monospaced":
          return Font.system(style, design: .monospaced)
      default:
          return Font.system(style, design: .default)
      }
  }
}
