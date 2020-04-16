//
//  WikiRequestManager.swift
//  WhatFlower
//
//  Created by Giorgi Shukakidze on 3/23/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol WikiRequestMangerDelegate {
    func didFetchData(_ wikiRequestManager: WikiRequestManager, text: String, imageURL: String)
}

struct WikiRequestManager {
    var delegate: WikiRequestMangerDelegate?
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    


    func requestWikiInfo(flowerName: String) {
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts|pageimages",
            "exintro" : "",
            "explaintext" : "",
            "titles" : flowerName,
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize" : "500"
        ]
        
        Alamofire.request(wikipediaURl, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                let flowerJSON: JSON = JSON(response.result.value!)
                let pageId = flowerJSON["query"]["pageids"][0].stringValue
                let flowerDescription = flowerJSON["query"]["pages"][pageId]["extract"].stringValue
                let imageURL = flowerJSON["query"]["pages"][pageId]["thumbnail"]["source"].stringValue
                
                self.delegate?.didFetchData(self, text: flowerDescription, imageURL: imageURL)
            }
        }
    }
}
