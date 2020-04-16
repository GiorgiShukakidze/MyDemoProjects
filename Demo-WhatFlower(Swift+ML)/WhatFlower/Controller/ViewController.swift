//
//  ViewController.swift
//  WhatFlower
//
//  Created by Giorgi Shukakidze on 3/22/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import CoreML
import Vision
import SDWebImage

class ViewController: UIViewController {
    
    var wikiRequestManager = WikiRequestManager()
    var userPickedImage: UIImage?
    
    @IBOutlet weak var imageToClassify: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wikiRequestManager.delegate = self
    }
    
    //MARK: - CoreML Methods
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: FlowerClassifier().model)
            let request = VNCoreMLRequest(model: model) { [weak self] (request, error) in
                self?.processClassification(for: request, error: error)
            }
            request.imageCropAndScaleOption = .centerCrop
            return request
        }catch {
            fatalError("Could not import model: \(error.localizedDescription)")
        }
    }()
    
    func updateRequest(for image: UIImage) {
        navigationItem.title = "Clasifying..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let convertedImage = CIImage(image: image) else {
                fatalError("Could not convert to CIImage!")
            }
            let handler = VNImageRequestHandler(ciImage: convertedImage)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification: \(error.localizedDescription)")
            }
        }
    }
    
    func processClassification(for request: VNRequest, error: Error?){
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.navigationItem.title = "Unable to clasify image"
                return
            }
            
            if results.isEmpty {
                self.navigationItem.title = "Could not identify image"
            } else {
                let topResult = results.first as? VNClassificationObservation
                self.navigationItem.title = topResult?.identifier.capitalized
                self.wikiRequestManager.requestWikiInfo(flowerName: topResult!.identifier)
            }
        }
    }
    

    //MARK: - Camera methods
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPicker(for: .photoLibrary)
            return
        }
        
        let chosePhotoAlert = UIAlertController()
        let cameraAction = UIAlertAction(title: "Open Camera", style: .default) { [unowned self] _ in
            self.presentPicker(for: .camera)
        }
        let photoLibraryAction = UIAlertAction(title: "Open Library", style: .default) { [unowned self] _ in
            self.presentPicker(for: .photoLibrary)
        }
        chosePhotoAlert.addAction(cameraAction)
        chosePhotoAlert.addAction(photoLibraryAction)
        chosePhotoAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(chosePhotoAlert, animated: true)
    }
    
    func presentPicker(for sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - Image Picker Delegate Methods
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.presentingViewController?.dismiss(animated: true)
        
        let pickedImage = info[.editedImage] as! UIImage
        imageToClassify.image = pickedImage
        updateRequest(for: pickedImage)
    }
}

//MARK: - Wiki request results

extension ViewController: WikiRequestMangerDelegate {
    
    func didFetchData(_ wikiRequestManager: WikiRequestManager, text: String, imageURL: String) {
        descriptionLabel.text = text
        imageToClassify.sd_setImage(with: URL(string: imageURL))
    }
}

