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
    @IBOutlet weak var itemImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func photoLibraryTapped(_ sender: UIBarButtonItem) {
        presentPicker(for: .photoLibrary)
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            presentPicker(for: .camera)
        } else {
            presentPicker(for: .photoLibrary)
        }
    }

    @IBAction func addItemTapped(_ sender: UIButton) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let newItem = Item(context: context)
            newItem.title = itemTitleTextField.text
            newItem.image = itemImageView.image?.jpegData(compressionQuality: 1.0)
            try? context.save()
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Utilities
    
    func presentPicker(for sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        
        present(picker, animated: true, completion: nil)
    }
    
}

extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            itemImageView.image = selectedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
