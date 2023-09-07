

import Foundation
import AVFoundation

class SoundPlayer {
  
  static var shared: SoundPlayer = .init()
  
  private init () {}
  
  var player: AVAudioPlayer?

  func playSound(fileName: String) {
      guard let path = Bundle.main.path(forResource: fileName, ofType:"wav") else {
          return }
      let url = URL(fileURLWithPath: path)

      do {
          player = try AVAudioPlayer(contentsOf: url)
          player?.play()
          
      } catch let error {
        Logger.shared.log(description: error.localizedDescription)
      }
  }
}

