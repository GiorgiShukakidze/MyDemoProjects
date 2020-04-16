//
//  Task.swift
//  The Night Porter
//
//  Created by Giorgi Shukakidze on 4/13/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import Foundation

enum TaskType {
    case daily, weekly, monthly
}

struct Task {
    var name: String
    var type: TaskType
    var isDone: Bool
    var lastCompleted: NSDate?
}
