//
//  ProfilePhotoUpload.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/3/21.
//

import Foundation

class UserService {
    func uploadUser(with user: User) {
        let session = URLSession.shared
        let url = URL(string: "https://whattsapppdatabase-f8e0.restdb.io/rest/whatsappcloneusers")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = Constant().headers
        
        let task = session.uploadTask(with: request, from: user.toJSONString()) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
                User.setCurrent(user, saveToDefaults: true)
            }
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
        }
        task.resume()
    }
    
    func getUser(username: String) {
        let query = "{\"username\": \"\(username)\"}"
        let session = URLSession.shared
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constant().urlHost
        components.path = "/rest/whatsappcloneusers"
        components.queryItems = [URLQueryItem(name: "q", value: query)]
        let url = components.url
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constant().headers
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse!)
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    print(json)
                }
            }
        })
        dataTask.resume()
    }
    
}


extension Encodable {
    func toJSONString() -> Data {
        let jsonData = try! JSONEncoder().encode(self)
        return jsonData
    }
    
}

