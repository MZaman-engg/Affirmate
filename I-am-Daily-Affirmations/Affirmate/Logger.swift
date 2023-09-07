

import Foundation
class Logger {
  static let shared: Logger = Logger()
  func log(description: Any, line: Int = #line, function: String = #function, className: String = #fileID) {
    print("\(className) : \(function) : \(line) : \(description).")
  }
}
