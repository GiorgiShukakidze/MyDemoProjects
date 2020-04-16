//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Giorgi Shukakidze on 2/26/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller does not exist!")
        }
        if let color = UIColor(hexString: "1D9BF6") {
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance().self
                appearance.backgroundColor = color
                appearance.largeTitleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.white]
                navBar.standardAppearance = appearance
                navBar.compactAppearance = appearance
                navBar.scrollEdgeAppearance = appearance
            } else {
                navBar.barTintColor = color
                navBar.largeTitleTextAttributes = [
                    NSAttributedString.Key.foregroundColor: UIColor.white]
            }
        }
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.backgroundColor) else {
                fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func deleteCellItem(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            }catch {
                print("Error while deleting item \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let categoryName = textField.text {
                let newCategory = Category()
                newCategory.name = categoryName
                newCategory.backgroundColor = UIColor.randomFlat().hexValue()
                self.save(category: newCategory)
            }
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
