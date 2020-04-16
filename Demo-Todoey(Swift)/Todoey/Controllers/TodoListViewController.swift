//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let category = selectedCategory, let color = UIColor(hexString: category.backgroundColor) {
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation Controller does not exist!")
            }
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance().self
                                
                appearance.backgroundColor = color
                appearance.largeTitleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: ContrastColorOf(color, returnFlat: true)]
             
                navBar.standardAppearance = appearance
                navBar.compactAppearance = appearance
                navBar.scrollEdgeAppearance = appearance
                navBar.tintColor = ContrastColorOf(color, returnFlat: true)
            } else {
                navBar.barTintColor = color
                navBar.tintColor = ContrastColorOf(color, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(color, returnFlat: true)]
            }
            title = category.name
            searchBar.barTintColor = color
            searchBar.searchTextField.backgroundColor = UIColor.white
        }
    }
    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.isDone ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.backgroundColor)?
                .darken(
                    byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)
            ) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                cell.tintColor = ContrastColorOf(color, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No Items Added "
        }
        return cell
    }
    
//  Delete item ---my code---
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if let item = todoItems?[indexPath.row], editingStyle == .delete  {
//            do{
//                try realm.write {
//                    realm.delete(item)
//                }
//            }catch {
//                print("Error while deleting item \(error.localizedDescription)")
//            }
//        }
//        tableView.reloadData()
//    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.isDone = !item.isDone
                }
            } catch {
                print("Error updating item:\(error.localizedDescription)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let itemTitle = textField.text, let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = itemTitle
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)                }
                } catch {
                    print("Error saving context: \(error.localizedDescription)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Model Manipulation Methods
    func save(item: Item) {
            do {
                try realm.write{
                    realm.add(item)
                }
            } catch {
                print("Error saving context: \(error.localizedDescription)")
            }
            tableView.reloadData()
    } 
    
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    override func deleteCellItem(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(item)
                }
            }catch {
                print("Error while deleting item \(error.localizedDescription)")
            }
        }
    }
}

//MARK: - Search bar delegate methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else{
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
}

