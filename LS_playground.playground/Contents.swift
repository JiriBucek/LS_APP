import Alamofire
import Foundation
import SwiftyJSON
import SwiftKeychainWrapper

let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDg3MDA1MTcsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC8iLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjgwODAvIiwidXNlcm5hbWUiOiJidWNlay5qaXJpQGVtYWlsLmN6In0.tbVlqWZnzmXuhJKR9qpxBymeHNQuqOWope9OhgGwwls"

let url = URL(string: "https://www.ay.energy/api/media/login")

let parameters: Parameters = ["username" : "bucek.jiri@email.cz", "password" : "Break1í345."]

let headers: HTTPHeaders = [
    "Authorization": "Bearer \(String(describing: token))",
    "Accept": "application/json"
]

let neco = KeychainWrapper.standard.string(forKey: "neco")
print(neco)

Alamofire.request(url!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate(statusCode: 200..<300)
    .responseData{ response in
        
        print(response.result)
        print(response.response)
        print(response.data?.base64EncodedString())

        }









