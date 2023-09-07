

import Foundation

// MARK: - Affirmation
struct Affirmation: Codable {
  let generalCategory: Category
  let categories: [CategoryElement]
  let backgrounds: [Background]
  let version: Int
  
  enum CodingKeys: String, CodingKey {
    case generalCategory = "General Category"
    case categories, backgrounds, version
  }
}

// MARK: - Background
struct Background: Codable {
    let title: String
    let backgroundImages: [BackgroundImage]

    enum CodingKeys: String, CodingKey {
        case title
        case backgroundImages = "background_images"
    }
}

// MARK: - BackgroundImage
struct BackgroundImage: Codable {
    let name, textColor, fontDesign: String

    enum CodingKeys: String, CodingKey {
        case name
        case textColor = "text_Color"
        case fontDesign = "font_design"
    }
}

// MARK: - CategoryElement
struct CategoryElement: Codable {
  let title: String
  let subCategories: [Category]
}

// MARK: - Category
struct Category: Codable {
  let name: String
  let quotes: [String]
}
