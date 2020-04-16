//
//  ViewController.swift
//  ImageIdentifier_(my_try)
//
//  Created by Giorgi Shukakidze on 3/21/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Vision Methods
    lazy var request: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MobileNetV2().model)
            let request = VNCoreMLRequest(model: model) { [weak self] (request, error) in
                self?.processClassifications(for: request, error: error)
            }
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Could not initialize model")
        }
    }()
    
    func updateClassifications(for image: UIImage) {
        textLabel.text = "Classifying..."
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Could not create CIImage!")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage)
            do {
                try handler.perform([self.request])
            } catch {
                print("Failed to perform classification: \(error.localizedDescription)")
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.textLabel.text = "Unable to classify image.\n: \(error!.localizedDescription)"
                return
            }
            
            let classificationResults = results as! [VNClassificationObservation]
            
            if classificationResults.isEmpty {
                self.textLabel.text = "Could not identify image!"
            } else{
                let topResults = classificationResults.suffix(2)
                let descriptions = topResults.map { classification in
                    return String(format: "(%.2f) %@", classification.confidence, classification.identifier)
                }
                self.textLabel.text = "Classification: \n" + descriptions.joined(separator: "\n")
            }
        }
    }
    
    
//MARK: - Handle Camera Actions
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPicker(for: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [unowned self] _ in
            self.presentPicker(for: .camera)
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { [unowned self] _ in
            self.presentPicker(for: .photoLibrary)
        }
        
        photoSourcePicker.addAction(cameraAction)
        photoSourcePicker.addAction(libraryAction)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true, completion: nil)
    }
    
    func presentPicker(for sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        
        present(picker, animated: true, completion: nil)
    }
    
}

//MARK: - Image Picker Delegate Methods
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        
        let pickedImage = info[.originalImage] as! UIImage
        photoView.image = pickedImage
        updateClassifications(for: pickedImage)
    }
}

