

import Foundation
class DownloadManager {
  
  static let shared: DownloadManager = DownloadManager.init()
  private var firebaseManager: FirebaseManager = .shared
  private var database: DataBase = .shared
  private var isFileDownloadInProgress: Bool = false
  private var isBackgroundsImagesDownloadInProgress: Bool = false
  
  func configure() {
    self.addInternetObserver()
  }
  /*
   Remove file from local document directory
   */
  private func deleteFile(destinationURL: URL) {
    if FileManager.default.isDeletableFile(atPath: destinationURL.path()) {
      do {
        try FileManager.default.removeItem(atPath: destinationURL.path())
      }catch {
        Logger.shared.log(description: error.localizedDescription)
      }
    }
  }
  
}

extension DownloadManager {
  
  private func addInternetObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(internetAvailable), name: AppSetting.NotificationName.internetAvailable, object: nil)
  }
  
  private func removeInternetObserver() {
    NotificationCenter.default.removeObserver(self, name: AppSetting.NotificationName.internetAvailable, object: nil)
  }
  
  @objc
  func internetAvailable() {
    downloadFile()
    downloadBackgrounds()
  }
}

extension DownloadManager {
  
  private func documentDirectoryURL() -> URL? {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
  }
  
  private func downloadableBackgrounds(documentDirectoryURL: URL,backgrounds: [String]) -> [String]{
    var downloadAbleBackgrounds: [String] = []
    for background in backgrounds {
      let filePath = documentDirectoryURL.appending(component: "\(background).jpg").path()
      if !FileManager.default.fileExists(atPath: filePath) {
        downloadAbleBackgrounds.append(background)
      }
    }
    return downloadAbleBackgrounds
  }
  
  private func backgroundImagesDirectoryURL() -> URL? {
    guard let documentDirectoryURL = documentDirectoryURL() else{
      Logger.shared.log(description: " document directory URL found nil")
      return nil
    }
    let backgroundsDirectoryURL = documentDirectoryURL.appending(component: "Backgrounds")
    let imagesDirectoryURL = backgroundsDirectoryURL.appending(component: "Images")
    if !directoryExistsAtPath(imagesDirectoryURL.path()) {
      do {
        try FileManager.default.createDirectory(at: imagesDirectoryURL, withIntermediateDirectories: true)
        return imagesDirectoryURL
      }catch {
        Logger.shared.log(description: " unable to create directory in document with URL : \(imagesDirectoryURL)")
        return nil
      }
    }else {
      return imagesDirectoryURL
    }
  }
  
  private func directoryExistsAtPath(_ path: String) -> Bool {
    var isDirectory: ObjCBool = true
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
  }
}

extension DownloadManager {
  
  /*
   //TODO:
      Also store videos for app backgrounds.
   */
  
  func downloadBackgrounds() {
    let backgroundImagesDirectoryURL = backgroundImagesDirectoryURL()
    guard let backgroundImagesDirectoryURL else {
      return
    }
    let backgrounds = database.backgrounds()
    let backgroundNames =  backgrounds.map { $0.backgroundImages }.map { images in
      images.map {  image in
        image.name
      }
    }.flatMap { $0 } 
    let downloadAbleBackgrounds = downloadableBackgrounds(documentDirectoryURL: backgroundImagesDirectoryURL, backgrounds: backgroundNames)
    guard !isBackgroundsImagesDownloadInProgress || downloadAbleBackgrounds.count == 0 else{
      return
    }
    isBackgroundsImagesDownloadInProgress = true
    Task {
      let _ = await firebaseManager.downloadBackgroundImage(imageNames: downloadAbleBackgrounds, destinationURL: backgroundImagesDirectoryURL)
      isBackgroundsImagesDownloadInProgress = false
    }
  }
  
  func downloadFile() {
    guard !isFileDownloadInProgress else {
      return
    }
    isFileDownloadInProgress = true
    Task {
      let latestFileVersion = await firebaseManager.checkLatestJsonFileVersion()
      if latestFileVersion > AppSetting.localFileVersion() {
        let fileName = AppSetting.affirmationsJsonFileName
        let fileURL = await firebaseManager.downloadJsonFile(fileName: fileName, ext: "json")
        Logger.shared.log(description: " downloaded file URl: \(String(describing: fileURL))")
        self.removeInternetObserver()
      }
      isFileDownloadInProgress = false
    }
  }
}
