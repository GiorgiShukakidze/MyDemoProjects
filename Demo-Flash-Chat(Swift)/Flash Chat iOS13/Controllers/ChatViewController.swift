//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Giorgi Shukakidze on 1/26/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
        messageTextfield.delegate = self
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (snapshot, error) in
                
            if let err = error {
                print("Could not fetch data: \(err.localizedDescription)")
            } else if let snapshotDocuments = snapshot?.documents {
                self.messages = []
                for doc in snapshotDocuments {
                    let data = doc.data()
                    if let messageBody = data[K.FStore.bodyField] as? String, let messageSender = data[K.FStore.senderField] as? String
                    {
                        let newMessage = Message(sender: messageSender, body: messageBody)
                        self.messages.append(newMessage)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                    }
                }
            }
        }
    }
    

    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
}

//MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.rightImageView.isHidden = false
            cell.leftImageView.isHidden = true
            cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
            cell.label.textAlignment = .right
        } else {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textAlignment = .left
        }
        return cell
    }
}

//MARK: - UITextFieldDelegate

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextfield.endEditing(true)
        return true
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        messageTextfield.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.bodyField: messageBody,
                K.FStore.senderField: messageSender,
                K.FStore.dateField: Date().timeIntervalSince1970
                ]) { (error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    print("Successfully sent!")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
}
