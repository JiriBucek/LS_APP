import Alamofire
import Foundation
import SwiftyJSON
import Alamofire
import AVFoundation


let fileManager = FileManager.default
let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
do {
    let urls = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
    print(urls)
    // process files
} catch {
    print("Error \(documentsURL.path): \(error.localizedDescription)")
}





