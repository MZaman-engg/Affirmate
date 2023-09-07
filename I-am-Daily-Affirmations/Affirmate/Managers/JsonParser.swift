

import Foundation

///  Repsonsible for JSON parsing
///
///
///  Example
///
///      let model = try? JsonParser<User>.decode(fileName: "fileName")
///
class JsonParser<T: Decodable> {
  
  static func decodeData(content: Data) throws -> T {
    try JSONDecoder().decode(T.self, from: content)
  }
  
}

extension JsonParser {
  enum ParsingErrors: Error {
    case noDataFound
  }
}
