import Alamofire
import Foundation
import SwiftyJSON
import SwiftKeychainWrapper
import AVFoundation


let url = URL(string: "http://68.183.64.160/media/meditations/Pozorovani_myslenek/voice.mp3")
let playerItem = AVPlayerItem(url: url!)
let player = AVPlayer(playerItem: playerItem)

player.play()
player.pause()








