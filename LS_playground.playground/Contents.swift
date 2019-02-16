import Alamofire
import Foundation
import SwiftyJSON
import Alamofire
import AVFoundation


let mujArray = [ "https://www.ay.energy//laskyplnysvet//media//images//meditations//pozorovani_myslenek.jpg", "https://www.ay.energy///laskyplnysvet///media///images///meditations///jedna_myslenka.jpg"]


func downloadFile(urlArray:[String])->Void{
    var urlArray = urlArray
    if let s3Url = urlArray.popLast(){
        let s3UrlUrl = URL(string: s3Url)
        Alamofire.request(s3UrlUrl!, method: .get , parameters: nil, encoding: URLEncoding.default, headers: nil)
            .downloadProgress { progress in
                print(progress.fractionCompleted)
            }
            .response { response in
                downloadFile(urlArray: mujArray)
        }
    }
}

downloadFile(urlArray: mujArray)



