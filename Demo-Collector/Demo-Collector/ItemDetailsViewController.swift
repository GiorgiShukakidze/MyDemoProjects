//
//  ItemDetailsViewController.swift
//  Demo-Collector
//
//  Created by Giorgi Shukakidze on 7/17/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    
    lazy var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var itemTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func photoLibraryTapped(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
    }

    @IBAction func addItemTapped(_ sender: UIButton) {
        
    }
    
}

extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
}
