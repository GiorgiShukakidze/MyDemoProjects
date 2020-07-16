//
//  AddNewItemViewController.swift
//  Demo-ToDo List
//
//  Created by Giorgi Shukakidze on 7/15/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class AddNewItemViewController: UIViewController {
    
    var toDoTableVC: ToDosTableViewController?

    @IBOutlet weak var toDoItemNameField: UITextField!
    @IBOutlet weak var isImportantSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addItemTapped(_ sender: UIButton) {
        
        if let title = toDoItemNameField.text, !title.isEmpty {
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let toDoItem = ToDoItem(context: context)
                toDoItem.name = title
                toDoItem.isImportant = isImportantSwitch.isOn
                
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                
                navigationController?.popViewController(animated: true)
            }
         }  else {
            
            let alert = UIAlertController(title: "No to do item title!", message: "Please enter to do list item title", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
