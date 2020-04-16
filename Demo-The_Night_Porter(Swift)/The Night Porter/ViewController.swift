//
//  ViewController.swift
//  The Night Porter
//
//  Created by Giorgi Shukakidze on 4/11/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var taksTableView: UITableView!
    
    var dailyTasks = [Task(name: "Check all windows", type: .daily, isDone: false, lastCompleted: nil),
                      Task(name: "Check all doors", type: .daily, isDone: false, lastCompleted: nil),
                      Task(name: "Is the boiler fueled?", type: .daily, isDone: false, lastCompleted: nil),
                      Task(name: "Check the mailbox", type: .daily, isDone: false, lastCompleted: nil),
                      Task(name: "Empty trash containers", type: .daily, isDone: false, lastCompleted: nil),
                      Task(name: "If freezing, check water pipes", type: .daily, isDone: false, lastCompleted: nil),
                      Task(name: "Document \"strange and unusual occurencies", type: .daily, isDone: false, lastCompleted: nil)
    ]
    
    var weeklyTasks = [Task(name: "Check inside all cabins", type: .weekly, isDone: false, lastCompleted: nil),
                       Task(name: "Flush all lavatories in cabin", type: .weekly, isDone: false, lastCompleted: nil),
                       Task(name: "Walk perimeter of property", type: .weekly, isDone: false, lastCompleted: nil)
    ]
    
    var monthlyTasks = [Task(name: "Test security alarms", type: .monthly, isDone: false, lastCompleted: nil),
                       Task(name: "Test motion detectors", type: .monthly, isDone: false, lastCompleted: nil),
                       Task(name: "Test smoke alarms", type: .monthly, isDone: false, lastCompleted: nil)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toggleDarkMode(_ sender: UISwitch) {
        
        if sender.isOn {
            view.backgroundColor = UIColor.darkGray
        } else{
            view.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func resetActionClicked(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure?", message: "All the data will be lost!", preferredStyle: .alert)
        
        let doAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            
            for i in 0..<self.dailyTasks.count {
                self.dailyTasks[i].isDone = false
            }
            
            for i in 0..<self.weeklyTasks.count {
                self.weeklyTasks[i].isDone = false
            }
            
            for i in 0..<self.monthlyTasks.count {
                self.monthlyTasks[i].isDone = false
            }
            
            self.taksTableView.reloadData()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel)
        
        alert.addAction(doAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - tableView Data Source methods
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        tableView.backgroundColor = UIColor.clear
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return dailyTasks.count
        case 1:
            return weeklyTasks.count
        case 2:
            return monthlyTasks.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        var currentTask: Task!
        
        switch indexPath.section {
        case 0:
            currentTask = dailyTasks[indexPath.row]
        case 1:
            currentTask = weeklyTasks[indexPath.row]
        case 2:
            currentTask = monthlyTasks[indexPath.row]
        default:
            cell.textLabel?.text = "Something went wrong..."
        }
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = currentTask.name
        cell.accessoryType = currentTask.isDone ? .checkmark : .none
        cell.textLabel?.textColor = currentTask.isDone ? UIColor.lightGray : UIColor.black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Daily Tasks"
        case 1:
            return "Weekly Tasks"
        case 2:
            return "Monthly Tasks"
        default:
            return nil
        }
    }
}

//MARK: - TableView Delegate methods

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let completeAction = UIContextualAction(style: .normal, title: "Done") { (action: UIContextualAction, view: UIView, actionPerformed: @escaping (Bool) -> Void) in
            
            switch indexPath.section {
            case 0:
                self.dailyTasks[indexPath.row].isDone = true
            case 1:
                self.weeklyTasks[indexPath.row].isDone = true
            case 2:
                self.monthlyTasks[indexPath.row].isDone = true
            default:
                break
            }
            
            tableView.reloadData()
            
            actionPerformed(true)
        }
         
        return UISwipeActionsConfiguration(actions: [completeAction])
    }

}

