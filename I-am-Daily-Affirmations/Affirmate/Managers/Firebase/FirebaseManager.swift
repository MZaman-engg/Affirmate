

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager {
  static let shared = FirebaseManager()
  private var remoteConfigManager: RemoteConfigManager!
  private var firebaseStorage: Storage!

  func configure() {
    FirebaseApp.configure()
    remoteConfigManager = .init()
    firebaseStorage = Storage.storage()
  }
  
  func downloadJsonFile(fileName: String, ext: String) async -> URL? {
    let fileNameWithExtension = fileName + "." + ext
    let reference = firebaseStorage.reference(withPath: fileNameWithExtension)
    guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      Logger.shared.log(description: " url to local document directory not found ")
      return nil
    }
    let localURL = documentDirectoryUrl.appending(component: fileNameWithExtension)
    do {
      return try await reference.writeAsync(toFile: localURL)
    }catch {
      Logger.shared.log(description: error.localizedDescription)
      return nil
    }
  }
  
  func downloadBackgroundImage(imageNames: [String], destinationURL: URL) async -> [URL] {
    /*
     Example:
        gs://affirmate-80415.appspot.com/Backgrounds/Images/bg1.jpg
     */
    var imagesLocalURLs: [URL] = []
    for imageName in imageNames {
      let imagePath = "Backgrounds/Images/\(imageName).jpg"
      let reference = firebaseStorage.reference(withPath: imagePath)
      do {
        let localURL = destinationURL.appending(component: "\(imageName).jpg")
        let URL = try await reference.writeAsync(toFile: localURL)
        imagesLocalURLs.append(URL)
      }catch {
        Logger.shared.log(description: error.localizedDescription)
      }
    }
    return imagesLocalURLs
  }
  
  func checkLatestJsonFileVersion() async -> Int {
      return await remoteConfigManager.latestVersionOfJsonFile()
  }
}
