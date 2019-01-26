import UIKit
import Alamofire

let user = "bucek.jiri@email.cz"
let password = "nt@8908KJ@we"
let requestString =  "https://www.ay.energy/api/media/meditations/"
let url = URL(string: requestString)


let headers: HTTPHeaders = [
    "username" : "bucek.jiri@email.cz",
    "password" : "nt@8908KJ@we"
]

let headers2: HTTPHeaders = [
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDg1Mjk5NzEsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC8iLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjgwODAvIiwidXNlcm5hbWUiOiJidWNlay5qaXJpQGVtYWlsLmN6In0.v2S2csXDjmjyNhreow5JkTzTxx0N0b30k0pJwqXpbYU",
    "Accept": "application/json"
]

let params: Parameters = [
"token" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDg1Mjk5NzEsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6ODA4MC8iLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjgwODAvIiwidXNlcm5hbWUiOiJidWNlay5qaXJpQGVtYWlsLmN6In0.v2S2csXDjmjyNhreow5JkTzTxx0N0b30k0pJwqXpbYU"
    
]


Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers2).validate().validate(contentType: ["application/json; charset=utf-8"])
    .responseJSON() { response in
        switch response.result {
            
            case .success:
                print("Success")
            case .failure(let error):
                print("Failure")
        }
    }
    .response { response in
        print("Request: \(String(describing: response.request))")
        print("Response: \(String(describing: response.response))")
        print("Error: \(String(describing: response.error))")
        
        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
            print("Data: \(utf8Text)")
        }
}





