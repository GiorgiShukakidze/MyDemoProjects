//
//  ViewController.swift
//  SeaFood
//
//  Created by Giorgi Shukakidze on 3/20/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var chosenPhotoView: UIImageView!
    @IBOutlet var noPhotoMessage: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.showsCameraControls = true
        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            noPhotoMessage[1].text = "Choose Photo from library."
        } else {
            noPhotoMessage[0].text = "Camera or Library is not available :(."
            noPhotoMessage[1].isHidden = true
        }
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
            present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - ImagePicker delegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            chosenPhotoView.image = selectedImage
            view.backgroundColor = .white
            
            for label in noPhotoMessage {
                if !label.isHidden {
                    label.isHidden = true
                }
            }
            
            guard let convertedImage = CIImage(image: selectedImage) else {
                fatalError("Could not convert to CIImage")
            }
            detect(for: convertedImage)
        }
        imagePicker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func detect(for image: CIImage){
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Could not load CoreML Model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "HotDog!"
                } else {
                    self.navigationItem.title = "Not HotDog."
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error.localizedDescription)
        }
    }
}
