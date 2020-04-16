//
//  NetworkManager.swift
//  Hacker News
//
//  Created by Giorgi Shukakidze on 2/9/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

class NetworkManager: ObservableObject {
    @Published var posts = [Post]()
    
    func fetchData() {
        if let url = URL(string: "https://hn.algolia.com/api/v1/search?tags=front_page") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    if let safeData = data {
                        let decoder = JSONDecoder()
                        do {
                            let results = try  decoder.decode(Results.self, from: safeData)
                            DispatchQueue.main.async {
                                self.posts = results.hits
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
