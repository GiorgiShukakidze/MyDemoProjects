//
//  Gist.swift
//  RESThub
//
//  Created by Giorgi Shukakidze on 4/22/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

struct Gist: Codable {
    let id: String?
    let isPublic: Bool
    let description: String
    let files: [String : File]
    
    enum CodingKeys: String, CodingKey {
        case id, description, files, isPublic = "public"
    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        
//        try container.encode(isPublic, forKey: .isPublic)
//        try container.encode(description, forKey: .description)
//    }
}

struct File: Codable {
    let content: String?
}

extension Gist {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.isPublic = try container.decode(Bool.self, forKey: .isPublic)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? "Description is nil"
        self.files = try container.decode([String : File].self, forKey: .files)
    }
}
