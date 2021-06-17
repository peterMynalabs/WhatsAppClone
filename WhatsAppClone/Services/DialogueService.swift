//
//  DialogueService.swift
//  WhatsAppClone
//
//  Created by Peter Shaburov on 6/17/21.
//

import Foundation

class DialogueService {
    func upload(dialogue: Dialogue) {
        let session = URLSession.shared
        let url = URL(string: "https://whattsapppdatabase-f8e0.restdb.io/rest/whatsappclonedialogues")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = Constant().headers
        
        let task = session.uploadTask(with: request, from: dialogue.toJSONString()) { data, response, error in
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print(dataString)
            }
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
            }
        }
        task.resume()
    }
    
    func getDialogue(from id: String) {
        let query = "{\"username\": \"\(id)\"}"
        let session = URLSession.shared
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constant().urlHost
        components.path = "/rest/whatsappclonedialogues"
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
    
    func getAllDialogues(recievedUsers: @escaping ([Dialogue]) -> Void){
        let session = URLSession.shared
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = Constant().urlHost
        components.path = "/rest/whatsappclonedialogues"
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
                if let _ = try? JSONSerialization.jsonObject(with: data!, options: []) {
                    let decoder = JSONDecoder()
                    let dialogues = try! decoder.decode([Dialogue].self, from: data!)
                    recievedUsers(dialogues)
                }
            }
        })
        dataTask.resume()
        recievedUsers([])
    }
    
}
