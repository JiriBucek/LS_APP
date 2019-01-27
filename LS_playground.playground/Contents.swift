import Alamofire
import Foundation
import SwiftyJSON

let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDg2MTU2MzgsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC8iLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjgwODAvIiwidXNlcm5hbWUiOiJidWNlay5qaXJpQGVtYWlsLmN6In0.fe-liVwgmZgmIQp97M6xnGcZUR9_1zAVPaghPy9pSD8"
let url = URL(string: "https://www.ay.energy/api/media/meditations")
let headers: HTTPHeaders = [
    "Authorization": "Bearer \(String(describing: token))",
    "Accept": "application/json"
]

Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
    .response() { response in
        
        do{
            let json = try JSON(data: response.data!)
            print(json)
        }catch{
            print("prd")
        }
    }




