//
//  ItemDetailsViewController.swift
//  Demo-ToDo List
//
//  Created by Giorgi Shukakidze on 7/15/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    var selectedItem: ToDoItem?

    @IBOutlet weak var selectedItemNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let item = selectedItem {
            selectedItemNameLabel.text = item.name
        }
    }
    
    @IBAction func completeTapped(_ sender: UIButton) {
        
        selectedItem?.isComplete = true
        navigationController?.popViewController(animated: true)
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
