//
//  PostData.swift
//  Hacker News
//
//  Created by Giorgi Shukakidze on 2/9/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

struct Results: Decodable {
    let hits: [Post]
}

struct Post: Decodable, Identifiable {
    var id: String {
        return objectID
    }
    let objectID: String
    let title: String
    let url: String?
    let points: Int
}

