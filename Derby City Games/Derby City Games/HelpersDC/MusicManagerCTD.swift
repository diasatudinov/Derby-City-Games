

import AVFoundation

class DCSoundManager {
    static let shared = DCSoundManager()
    var audioPlayer: AVAudioPlayer?

    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "musicBgDC", withExtension: "mp3") else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 
            audioPlayer?.play()
        } catch {
            print("Could not play background music: \(error)")
        }
    }

    func stopBackgroundMusic() {
        audioPlayer?.stop()
    }
}
