//
//  Category.swift
//  Todoey
//
//  Created by Giorgi Shukakidze on 2/26/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColor: String = ""
    let items = List<Item>()
}
