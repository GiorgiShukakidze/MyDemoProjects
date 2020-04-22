//
//  NewGistViewController.swift
//  RESThub
//
//  Created by Giorgi Shukakidze on 4/22/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class NewGistViewController: UIViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var fileNameTextView: UITextView!
    @IBOutlet weak var fileContentTextView: UITextView!
    @IBOutlet weak var createButton: UIButton! {
        didSet {
            createButton.layer.cornerRadius = 5
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        adjustTextView(textViews: [descriptionTextView, fileNameTextView, fileContentTextView])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }

    //MARK: - Create new gist
    
    @IBAction func createActionClicked(_ sender: UIButton) {
        
        let gist = Gist(id: nil, isPublic: true, description: descriptionTextView.text, files: [fileNameTextView.text : File(content: fileContentTextView.text)])
        
        DataService.shared.createNewGist(with: gist) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.showResultAlert(title: "Gist Created", message: "Successfully created test gist", isSuccess: true )
                case .failure(let error):
                    self.showResultAlert(title: "Ups...", message: "Could not create gist. Try again.", isSuccess: false)
                    print(error.localizedDescription)
                }
            }
        }
    }


    //MARK: - Utilities functions
    
    func adjustTextView (textViews: [UITextView]) {
        for textView in textViews {
            textView.layer.borderWidth = 1
            textView.layer.cornerRadius = 10
            textView.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.1)
        }
    }
    
    func showResultAlert(title: String, message: String, isSuccess:Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
                     if isSuccess {
                        self.navigationController?.viewControllers.removeLast()
               }
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
