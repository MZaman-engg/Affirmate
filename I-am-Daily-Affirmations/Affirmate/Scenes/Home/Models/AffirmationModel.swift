

import Foundation

struct AffirmationModel: Identifiable {
  var id: UUID = UUID()
  let text: String
  var isFavourite: Bool
}

struct AffirmationThemeModel: Identifiable {
  let id: UUID = .init()
  let imageData: Data
  let textColor, fontDesign: String
}

struct AffirmationBackgroundModel: Identifiable {
  let id: UUID = .init()
  let backgroundColor: String
  let textColor, fontDesign: String
}
