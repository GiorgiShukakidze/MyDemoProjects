//
//  Item.swift
//  Todoey
//
//  Created by Giorgi Shukakidze on 2/26/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
