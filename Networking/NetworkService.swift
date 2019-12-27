//
//  NetworkService.swift
//  Sauron
//
//  Created by Horacio Guzman on 11/21/18.
//

import Foundation


internal class NetworkService{
    
    private static let domain = "https://backend-dot-desarrollo-idt-turismo.appspot.com/api/v1"
    
    public static func sendAnalytic(analytics: [Analytic2Send], completion: @escaping (Error?)->Void){
        
        //////print("Send click NetworkService")
        
        let url = URL(string: "\(NetworkService.domain)/analytics")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let envio = [
            "analyticsRecords": analytics
        ]
        
        do{
            let jsonData = try JSONEncoder().encode(envio)
            request.httpBody = jsonData
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, response, error) in
                
                //////print("Send click NetworkService finish")
                
                if let error = error{
                    //////print("Error: \(error.localizedDescription)")
                    completion(error)
                }
                
                guard let data = data else{
                    completion(SauronError(description: "Sending click error Data doesnt present"))
                    return
                }
                
                if let response = response as? HTTPURLResponse{
                    if response.statusCode == 200{
                        completion(nil)
                    }else{
                        //print("\(String(data: data, encoding: .utf8) ?? "Response error: \(response.statusCode)")")
                        //print("Data Sended: ")
                        //print("\(String(data: jsonData, encoding: .utf8) ?? "Response error: \(response.statusCode)")")
                        completion(SauronError(description: "Service Error: \(response.statusCode)"))
                    }
                }
            }
            task.resume()
        }catch{
            //////print("Sending click error: \(error.localizedDescription)")
            //////print(error)
            completion(error)
        }
        
        
    }
    
    public static func sendString(string: String, completion: @escaping (Error?)->Void){
        
        let url = URL(string: "\(NetworkService.domain)/receiver")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let envio = [
            "message": ["data" : string]
        ]
        
        do{
            let jsonData = try JSONEncoder().encode(envio)
            request.httpBody = jsonData
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, response, error) in
                
                //////print("Send click NetworkService finish")
                
                if let error = error{
                    //////print("Error: \(error.localizedDescription)")
                    completion(error)
                }
                
                guard let _ = data else{
                    completion(SauronError(description: "Sending string error Data doesnt present"))
                    return
                }
                
                if let response = response as? HTTPURLResponse{
                    if response.statusCode == 200{
                        completion(nil)
                    }else{
                        ////print("\(String(data: data, encoding: .utf8) ?? "Response error: \(response.statusCode)")")
                        completion(SauronError(description: "Service Error: \(response.statusCode)"))
                    }
                }
            }
            task.resume()
        }catch{
            //////print("Sending click error: \(error.localizedDescription)")
            //////print(error)
            completion(error)
        }
    }
    
    public static func sendImages(images: [String], completion: @escaping (Error?)->Void){
        
        let url = URL(string: "\(NetworkService.domain)/pctrncdd")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        let envio = SendImages(images: images)
        
        do{
            let jsonData = try JSONEncoder().encode(envio)
            request.httpBody = jsonData
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (data, response, error) in
                
                ////print("sendImages NetworkService finish")
                
                if let error = error{
                    //////print("Error: \(error.localizedDescription)")
                    completion(error)
                }
                
                guard let _ = data else{
                    completion(SauronError(description: "Sending images error Data doesnt present"))
                    return
                }
                
                if let response = response as? HTTPURLResponse{
                    if response.statusCode == 200{
                        completion(nil)
                    }else{
                        ////print("\(String(data: data, encoding: .utf8) ?? "Response error: \(response.statusCode)")")
                        completion(SauronError(description: "Service Error: \(response.statusCode)"))
                    }
                }
            }
            task.resume()
        }catch{
            //////print("Sending click error: \(error.localizedDescription)")
            //////print(error)
            completion(error)
        }
    }
    
}
