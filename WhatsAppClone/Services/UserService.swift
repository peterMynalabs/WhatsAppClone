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
    
    func getUser(phoneNumber: String, recieved: @escaping (User?) -> Void) {
        print(phoneNumber)
        let query = "{\"phoneNumber\": \"\(phoneNumber)\"}"
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
                recieved(nil)
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.mutableContainers]) as? NSArray {
                    for item in json {
                        let dict = item as! [String: String]
                        
                        if let uid = dict["uid"],
                           let name = dict["name"],
                           let number = dict["phoneNumber"] {
                            recieved(User(uid: uid, name: name, phoneNumber: number))
                        } else {
                            recieved(nil)
                        }
                    }
                } else {
                    recieved(nil)
                }
            }
        })
        dataTask.resume()
    }
    
    func getAllUsers(recievedUsers: @escaping ([User]) -> Void){
        let session = URLSession.shared
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constant().urlHost
        components.path = "/rest/whatsappcloneusers"
        let url = components.url
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = Constant().headers
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                if let _ = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    let decoder = JSONDecoder()
                    let allBlogPosts = try! decoder.decode([User].self, from: data!)
                    print(allBlogPosts)
                    recievedUsers(allBlogPosts)
                }
            }
        })
        dataTask.resume()
        recievedUsers([])
    }
    
}


extension Encodable {
    func toJSONString() -> Data {
        let jsonData = try! JSONEncoder().encode(self)
        return jsonData
    }
    
}

