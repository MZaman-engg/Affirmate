

import Foundation
struct AppSetting {
  static private var database: DataBase = .shared
  static var appName =  "Affirmate" 
  static let affirmationsJsonFileName: String = "Affirmations"
  static let colorBackground: String = "COLOR-BACKGROUND"
  struct LocalStorage {
    static let selectedCategory: String = "SELECTED-CATEGORY-KEY"
    static let selectedTheme: String = "SELECTED-THEME-KEY"
  }
  struct NotificationName {
    static let internetAvailable = Notification.Name( "INTERNET-AVAILABLE")
  }
  struct Firebase {
  }
  
  static func localFileVersion() -> Int {
    database.localFileVersion()
  }
}
