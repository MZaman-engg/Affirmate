

import Foundation

struct RemainderDayModel: Identifiable {
  var id: UUID = .init()
  var isSelected: Bool
  var name: String
  var number: Int
}

struct ReminderCategory: Identifiable {
  var id: UUID = .init()
  var section: String
  var categories: [String]
}

struct ReminderSound: Identifiable {
  var id: UUID = .init()
  var fileName: String
  var name: String
}
