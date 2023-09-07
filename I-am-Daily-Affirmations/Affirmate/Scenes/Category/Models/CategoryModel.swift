

import Foundation

struct CategoryModel: Identifiable {
  let id: UUID = UUID()
  let name: String
  var subCategoryModel: [SubCategoryModel]
}

struct SubCategoryModel: Identifiable {
  let id: UUID = UUID()
  let name: String
  let isSelected: Bool
}

