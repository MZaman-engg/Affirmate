

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
  
  // MARK: - Private Variables
  private let database: DataBase = .shared
  private var favouritesQuotes: [AffirmationModel] = []

  // MARK: - AppStorage variables
  @AppStorage(AppSetting.LocalStorage.selectedCategory) var selectedCategory = ""
  @AppStorage(AppSetting.LocalStorage.selectedTheme) var selectedTheme = ""
  @AppStorage("fontDesign") var fontDesign = "monospaced"
  @AppStorage("textColor") var textColor = "#9FC088"
  @AppStorage("backgroundColor") var backgroundColor = "#CC704B"
  
  // MARK: - Published variables
  @Published var affirmations: [AffirmationModel] = []
  @Published var selectedThemeBackground: AffirmationThemeModel = AffirmationThemeModel(imageData: UIImage(named: "bg1")?.pngData() ?? Data() , textColor: "#FFFFFF", fontDesign: "monospaced")
  
  @Published var selectedColorBackground: AffirmationBackgroundModel = AffirmationBackgroundModel(backgroundColor: "#CC704B", textColor: "#9FC088", fontDesign: "monospaced")
    
  init() {
    database.readFile()
    database.getBackgrounds()
    getAffirmations()
    getSelectedTheme()
  }
}

extension HomeViewModel {
  
  /*
   TODO:
   Initially presenting general affirmations. ✅
   In future is will be filled according to user selected category. ✅
   Need to handle favourites , save them in realm. ✅
   */
  
  func getAffirmations() {
    if selectedCategory == "Favourites" {
      let favouritesQuotes = database.getFavoriteQuotes()
      self.favouritesQuotes = favouritesQuotes.map({ favouritesModel in
        AffirmationModel(id: favouritesModel._id, text: favouritesModel.quote, isFavourite: true)
      })
      self.affirmations = self.favouritesQuotes
      return
    }
    let affirmations =  database.affirmations()
    guard let affirmations else{
      Logger.shared.log(description: " unable to get affirmations from database ")
      return
    }
    var quotes: [String] = []
    if selectedCategory == "" || selectedCategory == affirmations.generalCategory.name {
      selectedCategory = affirmations.generalCategory.name
      quotes = affirmations.generalCategory.quotes
    }
    else {
      let categories = affirmations.categories
      for category in categories {
        let selectedCategory = category.subCategories.filter {$0.name == self.selectedCategory}
        if let selected = selectedCategory.first {
          quotes = selected.quotes
          break
        }
      }
    }
    var selectedCategoryAffirmations: [AffirmationModel] = []
    for quote in quotes {
      selectedCategoryAffirmations.append(AffirmationModel(text: quote, isFavourite: false))
    }
    self.affirmations = selectedCategoryAffirmations.shuffled()
  }
  
  func getSelectedTheme() {
    if selectedTheme == AppSetting.colorBackground{
      return
    }
    if selectedTheme != "" {
      guard let imageData = database.backgroundsImagesData().filter({$0.key == selectedTheme}).values.first else {
        return
      }
      guard let model =  database.backgrounds().compactMap({$0.backgroundImages}).flatMap({$0}).filter({$0.name == selectedTheme}).first else {
        return
      }
      selectedThemeBackground = AffirmationThemeModel(imageData: imageData, textColor: model.textColor, fontDesign: model.fontDesign)
    }
  }
  
  func setColorBackground(colorBackground: BackgroundModel) {
    self.selectedColorBackground = AffirmationBackgroundModel(backgroundColor: colorBackground.backgroundColor, textColor: colorBackground.textColor, fontDesign: colorBackground.fontDesign)
    self.fontDesign = colorBackground.fontDesign
    self.textColor = colorBackground.textColor
    self.backgroundColor = colorBackground.backgroundColor
  }
  
  func setTheme(theme: BackgroundImagesModel) {
    self.selectedThemeBackground = AffirmationThemeModel(imageData: theme.imageData, textColor: theme.textColor, fontDesign: theme.fontDesign)
  }
}

extension HomeViewModel {
  
  func addToFavorites(model: AffirmationModel) {
    let favouriteModel = FavouriteModel()
    favouriteModel._id = model.id
    favouriteModel.categoryName = selectedCategory
    favouriteModel.quote = model.text
    database.addToFavorites(favouriteModel)
  }
  
  func removeFromFavorites(model: AffirmationModel) {
    if selectedCategory == "Favourites" {
      affirmations.removeAll { affirmationModel in
        affirmationModel.text == model.text
      }
    }
    database.removeFromFavorites(model.id)
  }
  
}
