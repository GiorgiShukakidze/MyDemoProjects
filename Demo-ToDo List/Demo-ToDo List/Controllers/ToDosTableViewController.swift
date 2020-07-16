//
//  ToDosTableViewController.swift
//  Demo-ToDo List
//
//  Created by Giorgi Shukakidze on 7/15/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

let itemCellIdentifier = "toDoItem"
let toDoDetailsSegue = "toDoDetails"

class ToDosTableViewController: UITableViewController {
    
    var toDoItems = [ToDoItem]()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    override func viewWillAppear(_ animated: Bool) {
        getToDoItems()
    }
    
    func getToDoItems() {
        if let viewContext = context {
            if let itemsResult = try? viewContext.fetch(ToDoItem.fetchRequest()) as? [ToDoItem] {
                toDoItems = itemsResult
                
                tableView.reloadData()
            }
            
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier, for: indexPath)
        
        let item = toDoItems[indexPath.row]
        let itemTitle = item.isImportant ? "❗️ \(item.name ?? "")" : item.name
        
        cell.textLabel?.numberOfLines = 0
        
        var attributes = [NSAttributedString.Key : Any]()
        if item.isComplete {
            attributes = [.strikethroughColor : UIColor.red, .strikethroughStyle : 1]
        }
        
        cell.textLabel?.attributedText = NSAttributedString(string: itemTitle ?? "", attributes: attributes)

        return cell
    }
    
    //MARK: - Table view delegate


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let viewContext = context {
                viewContext.delete(toDoItems[indexPath.row])
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                
                toDoItems.remove(at: indexPath.row)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = toDoItems[indexPath.row]
        performSegue(withIdentifier: toDoDetailsSegue, sender: item)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? ItemDetailsViewController,
            let toDoItem = sender as? ToDoItem {
            destinationVC.selectedItem = toDoItem
        }
        
        if let destinationVC = segue.destination as? AddNewItemViewController {
            destinationVC.toDoTableVC = self
        }
    }

}
