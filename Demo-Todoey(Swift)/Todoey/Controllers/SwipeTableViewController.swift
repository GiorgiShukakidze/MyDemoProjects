//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Giorgi Shukakidze on 2/28/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65.0
        tableView.separatorStyle = .none
    }
    
    func deleteCellItem(at indexPath: IndexPath) {
        // Delete selected cell item for cell
    }
    
    //MARK: - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
         
        return cell
    }
    
    //MARK: - Swipe delegate methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteCellItem(at: indexPath)
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "trash-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .drag
        return options
    }
}
