

import Foundation
import RealmSwift
/// Responsible for all database operations
///
/// Example:
///
///     DataBase.shared.methodName()
///
class DataBase {
  static let shared: DataBase = DataBase()
  private var content: Affirmation?
  private var realm: RealmDataManager = .shared
  private var backgroundImages: [String : Data] = [:]
  
  func affirmations() -> Affirmation? {
    return content
  }
  
  func backgrounds() -> [Background] {
    return content?.backgrounds ?? []
  }
  
  func backgroundsImagesData() -> [String : Data] {
    backgroundImages
  }
  
  func localFileVersion() -> Int {
    return content?.version ?? 1
  }
  
  private func documentDirectoryURL() -> URL? {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  }
  
  private func directoryExistsAtPath(_ path: String) -> Bool {
    var isDirectory: ObjCBool = true
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
  }

}

extension DataBase {
  
  func getBackground(with name: String) -> BackgroundImage? {
    guard let documentDirectoryURL = documentDirectoryURL() else {
      Logger.shared.log(description: " unable to get the document directory URL ")
      return nil
    }
    let imageDirectoryURL = documentDirectoryURL.appending(component: "Backgrounds").appending(components: "Images")
    if directoryExistsAtPath(imageDirectoryURL.path()) {
      let imageURL = imageDirectoryURL.appending(component: name+".jpg")
      do {
        let _ = try Data(contentsOf: imageURL)
      }catch {
        Logger.shared.log(description: error.localizedDescription)
      }
    }
    return nil
  }
  
  func getBackgrounds() {
    guard let documentDirectoryURL = documentDirectoryURL() else {
      Logger.shared.log(description: " unable to get the document directory URL ")
      return
    }
    let imageDirectoryURl = documentDirectoryURL.appending(component: "Backgrounds").appending(components: "Images")
    if directoryExistsAtPath(imageDirectoryURl.path()) {
      fetchBackgrounds(directoryURL: imageDirectoryURl)
    }
  }
  
  private func fetchBackgrounds(directoryURL: URL) {
    do {
      let backgroundImagesURL = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil)
      for imageURL in backgroundImagesURL {
        let imageData = try Data(contentsOf: imageURL)
        guard let imageName = imageURL.lastPathComponent.split(separator: ".").first else {
          Logger.shared.log(description: " unable to get the name of image from imageURL ")
          return
        }
        self.backgroundImages[String(imageName)] = imageData
      }
    }catch {
      Logger.shared.log(description: error.localizedDescription)
    }
  }
}

extension DataBase {
  
  func readFile() {
    let fileName = AppSetting.affirmationsJsonFileName
    let fileData = readFile(fileName: fileName)
    guard let fileData else {
      Logger.shared.log(description: " file data not found : \(fileName)")
      return
    }
    do {
      content = try JsonParser<Affirmation>.decodeData(content: fileData)
    }catch {
      Logger.shared.log(description: "Error occurred : \(error)")
    }
  }
  
  private func readFile(fileName: String) -> Data? {
    if let dataFromDocumentDirectory = readFileFromDocumentDirectory(fileName: fileName) {
      return dataFromDocumentDirectory
    } else {
      return readFileFromBundle(fileName: fileName)
    }
  }
  
  private  func readFileFromBundle(fileName: String) -> Data? {
    guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "json") else {
      Logger.shared.log(description: "No file found with name : \(fileName)")
      return nil
    }
    return try? Data(contentsOf: fileUrl)
  }
  
  private func readFileFromDocumentDirectory(fileName: String) -> Data? {
    guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else{
      Logger.shared.log(description: "No file found with name : \(fileName)")
      return nil
    }
    let fileUrl = documentDirectoryUrl.appending(component: fileName+".json")
    return try? Data(contentsOf: fileUrl)
  }
  
}

extension DataBase {
  
  func getFavoriteQuotes() -> [FavouriteModel] {
    return realm.objects(FavouriteModel.self)
  }
  
  func addToFavorites (_ favoriteQuote: FavouriteModel ) {
    if realm.objectForAttribute(FavouriteModel.self, attribute: "quote", value: favoriteQuote.quote).count > 0 {
      return
    }
    realm.create(favoriteQuote)
  }
  
  func removeFromFavorites(_ primaryKey: UUID) {
    realm.deleteUsingPrimaryKey(FavouriteModel.self, primaryKey: primaryKey)
  }
  
  func resetRealm() {
    guard let url = Realm.Configuration.defaultConfiguration.fileURL else {
      return
    }
    try? FileManager.default.removeItem(at: url)
  }
  
}
