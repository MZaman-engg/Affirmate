

import Foundation
import SwiftUI
import FirebaseRemoteConfig

class RemoteConfigManager {
  private let remoteConfig: RemoteConfig = RemoteConfig.remoteConfig()
  private var isFetchedValues: Bool = false
  
  @AppStorage(RemoteConfigKey.fileVersion.rawValue) var fileVersion: Int = 1
  
  func latestVersionOfJsonFile() async -> Int {
    _ = await fetchValues()
    return getLatestFileVersion()
  }
  
  private func getLatestFileVersion() -> Int {
    let fileVersion =  remoteConfig.configValue(forKey: RemoteConfigKey.fileVersion.rawValue).numberValue as? Int
    return fileVersion ?? self.fileVersion
  }
  
  private func fetchValues() async -> Bool {
    /*
     RemoteConfig available values:
     1. version
     */
    let defaultValues: [String:NSObject] = [
      RemoteConfigKey.fileVersion.rawValue : AppSetting.localFileVersion() as NSObject
    ]
    remoteConfig.setDefaults(defaultValues)
    let settings = RemoteConfigSettings()
    #if DEBUG
    settings.minimumFetchInterval = 0
    #endif
    remoteConfig.configSettings = settings
    return await withCheckedContinuation { continuation in
      remoteConfig.fetch(withExpirationDuration: 0) { [weak self] status, error in
        guard let strongSelf = self else {
          continuation.resume(returning: false)
          return
        }
        if status == .success && error == nil {
          strongSelf.remoteConfig.activate { _, error in
            if error == nil {
              continuation.resume(returning: true)
            }else {
              continuation.resume(returning: false)
            }
          }
        }else {
          continuation.resume(returning: false)
          Logger.shared.log(description: "Error in fetching the values from remoteConfig : \(String(describing: error))")
        }
      }
    }
  }
}

extension RemoteConfigManager {
  enum RemoteConfigKey: String {
    case fileVersion = "version"
  }
}
