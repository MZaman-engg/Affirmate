

import Foundation
import SwiftUI

class ThemeViewModel: ObservableObject {
  
  @Published var backgrounds: [ThemeModel] = []
  @Published var selectedBackgroundImage: [BackgroundImagesModel] = []
  @Published var selectedColorBackground: BackgroundModel!
  @Published var backgroundColor: Color
  @Published var textColor: Color
  @Published var fontDesign: String
  @Published var presentFontDesignList: Bool = false
  @Published var sheetHeight: CGFloat = .zero
  private let database: DataBase = .shared
  let selectedTheme: String
  var availableFonts: [String] = [
    "default",
    "monospaced",
    "rounded",
    "serif"
  ]
  
  init(selectedTheme: String, textColor: String, fontDesign: String , backgroundColor: String ) {
    self.selectedTheme = selectedTheme
    self.backgroundColor = Color(hex: backgroundColor)
    self.textColor = Color(hex: textColor)
    self.fontDesign = fontDesign
    selectedColorBackground = BackgroundModel(backgroundColor: backgroundColor,name: AppSetting.colorBackground, textColor: textColor, fontDesign: fontDesign)
    self.getBackgrounds()
    self.selectedBackgroundImage = selectedBackgrounds()
  }
  
  func getSelectedBackground() -> BackgroundModel {
    return BackgroundModel(backgroundColor: backgroundColor.toHex(),name: AppSetting.colorBackground, textColor: textColor.toHex(), fontDesign: fontDesign)
  }
  
  private func getBackgrounds() {
    let backgrounds = database.backgrounds()
    let imagesDataWithName = database.backgroundsImagesData()
    for background in backgrounds {
      var imagesData: [BackgroundImagesModel] = []
      for image in imagesDataWithName {
        if background.backgroundImages.contains(where: {$0.name == image.key}) {
          let availableBackground = background.backgroundImages.filter {$0.name == image.key}.first
          guard let availableBackground else {
            return
          }
          imagesData.append(BackgroundImagesModel(imageData: image.value, name: image.key, textColor: availableBackground.textColor, fontDesign: availableBackground.fontDesign,isSelected: availableBackground.name == selectedTheme))
        }
      }
      self.backgrounds.append(ThemeModel(backgroundImages: imagesData, title: background.title))
    }
  }
  
  private func selectedBackgrounds() -> [BackgroundImagesModel]{
    var selectedBackgrounds: [BackgroundImagesModel] = []
    for background in backgrounds {
      for image in background.backgroundImages {
        if image.isSelected {
          selectedBackgrounds.append(image)
        }
      }
    }
    return selectedBackgrounds
  }
}
