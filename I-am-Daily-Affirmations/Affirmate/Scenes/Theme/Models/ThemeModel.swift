

import Foundation

struct ThemeModel: Identifiable {
  let id: UUID = UUID()
  let backgroundImages: [BackgroundImagesModel]
  let title: String
}

struct BackgroundImagesModel: Identifiable {
  let id: UUID = UUID()
  let imageData: Data
  let name, textColor, fontDesign: String
  let isSelected: Bool
}

struct BackgroundModel: Identifiable {
  let id: UUID = UUID()
  var backgroundColor: String
  let name, textColor, fontDesign: String
}
