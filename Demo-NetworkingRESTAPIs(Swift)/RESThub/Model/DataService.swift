//
//  DataService.swift
//  RESThub
//
//  Created by Giorgi Shukakidze on 4/21/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

class DataService {
    static let shared = DataService()
    
//MARK: - Fetch data
    
    func fetchGists(completion: @escaping (Result<[Gist], Error>) -> Void) {
        
        guard let validURL = createURL(path: "/gists/public").url else {
            print("URL creation failed...")
            return
        }
        
        URLSession.shared.dataTask(with: validURL) { (data, response, error) in
            
            if let httpReponse = response as? HTTPURLResponse {
                print("API Status: \(httpReponse.statusCode)")
            }
            
            guard let validData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let gists = try JSONDecoder().decode([Gist].self, from: validData)
                completion(.success(gists))
            } catch let serializationError {
                completion(.failure(serializationError))
            }
            
        }.resume()
    }
    
    //MARK: - Post data
    
    func createNewGist(with gist: Gist, completion: @escaping (Result<Any, Error>) -> Void) {
        
        guard let validURL = createURL(path: "/gists").url else {
            print("URL creation failed...")
            return
        }
        
       var postRequest = createRequest(with: validURL, method: "POST")
        
        do {
            let gistData = try JSONEncoder().encode(gist)
            postRequest.httpBody = gistData
        } catch {
            completion(.failure(error))
        }
        
        URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
            }
            
            guard let validData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let dataJson = try JSONSerialization.jsonObject(with: validData, options: [])
                completion(.success(dataJson))
            } catch {
                print("Failed to serialize jason \(error.localizedDescription)")
            }
            
            completion(.success(validData))
        }.resume()
        
    }
    
    //MARK: - Star and Unstar Gist
    
    func starUnstar(for id: String, star: Bool, Completion: @escaping (Bool) -> Void) {
        
        guard let requestURL = createURL(path: "/gists/\(id)/star").url else {
            print("URL initialization failed...")
            return
        }
        
        var starUnstarRequest = createRequest(with: requestURL, method: star ? "PUT" : "DELETE")
        starUnstarRequest.addValue("0", forHTTPHeaderField: "Content-Length")
        
        URLSession.shared.dataTask(with: starUnstarRequest) { (data, response, error) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Star and unstar request status code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 204 {
                    Completion(true)
                } else {
                   Completion(false)
                }
            }
        }.resume()
    }
    
    
    //MARK: - Utilities functions
    
    func createURL(path: String) -> URLComponents {
        
        var componentURL = URLComponents()
        componentURL.scheme = "https"
        componentURL.host = "api.github.com"
        componentURL.path = path
        
        return componentURL
    }
    
    func createRequest(with url: URL, method: String) -> URLRequest {
        
        var request = URLRequest(url: url)
               request.httpMethod = method
               request.addValue("Token \(UserCredentials.token)", forHTTPHeaderField: "Authorization")
               request.addValue("application/json", forHTTPHeaderField: "Content-Type")
               request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }

}
