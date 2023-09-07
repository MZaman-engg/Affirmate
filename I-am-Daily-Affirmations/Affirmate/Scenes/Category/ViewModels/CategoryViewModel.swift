

import Foundation
import SwiftUI

class CategoryViewModel: ObservableObject {
  
  // MARK: - Private variables
  private let database: DataBase = .shared
  
  // MARK: - Published variables
  @Published var categories: [CategoryModel] = []
  @Published var generalCategories: [SubCategoryModel] = []
  @Published var selectedCategoryModel: SubCategoryModel!
  
  // MARK: - AppStorage variables
  private var selectedCategory: String
  
  // MARK: - Initializers
  init(selectedCategoryName: String) {
    self.selectedCategory = selectedCategoryName
    getCategory()
    getGeneralCategories()
  }
  
  func getCategory() {
    let categories = database.affirmations()?.categories
    guard let categories else {
      Logger.shared.log(description: " categories not found in database ")
      return
    }
    for category in categories {
      let subCategories = category.subCategories.map { category in
        SubCategoryModel(name: category.name, isSelected: category.name == selectedCategory)
      }
      if let selectedCategoryModel = category.subCategories.filter({ $0.name == selectedCategory}).first {
        self.selectedCategoryModel = SubCategoryModel(name: selectedCategoryModel.name, isSelected: true)
      }
      self.categories.append(CategoryModel(name: category.title, subCategoryModel: subCategories))
    }
  }
  
  func getGeneralCategories() {
    guard let generalCategory = database.affirmations()?.generalCategory else {
      Logger.shared.log(description: " general categories not found in database ")
      return
    }
    self.generalCategories.append(SubCategoryModel(name: generalCategory.name, isSelected: generalCategory.name == selectedCategory))
    self.generalCategories.append(SubCategoryModel(name: "Favourites", isSelected: "Favourites" == selectedCategory))
  }
  
}
