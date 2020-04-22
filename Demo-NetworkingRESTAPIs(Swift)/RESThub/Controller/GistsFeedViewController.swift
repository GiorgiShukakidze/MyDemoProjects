//
//  ViewController.swift
//  RESThub
//
//  Created by Giorgi Shukakidze on 4/21/20.
//  Copyright © 2020 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class GistsFeedViewController: UIViewController {
    
    var gistsFeed = [Gist]()
    @IBOutlet weak var feedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
                
        DataService.shared.fetchGists { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let gists):
                    self.gistsFeed = gists
                    self.feedTableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    //MARK: - Utility functions
    
    func showResultAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        present(alert, animated: true, completion: nil)
    }

}

//MARK: - Table View Delegate and Data Source methods

extension GistsFeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gistsFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCellID", for: indexPath)
        let currentGist = gistsFeed[indexPath.row]
        cell.textLabel?.text = currentGist.description
        cell.detailTextLabel?.text = currentGist.id
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentGist = gistsFeed[indexPath.row]
        let starAction = UIContextualAction(style: .normal, title: "Star") { (action, view, completion) in
            
            DataService.shared.starUnstar(for: currentGist.id!, star: true) { (isSuccess) in
                DispatchQueue.main.async {
                    if isSuccess {
                        self.showResultAlert(title: "Gist starred!", message: "Gist successfully starred!")
                    } else {
                        self.showResultAlert(title: "Ups...", message: "Could not star gist. Try again.")
                    }
                }
            }
            completion(true)
        }
        
        let unstarAction = UIContextualAction(style: .normal, title: "Unstar") { (action, view, completion) in
            
            DataService.shared.starUnstar(for: currentGist.id!, star: false) { (isSuccess) in
                DispatchQueue.main.async {
                    if isSuccess {
                        self.showResultAlert(title: "Gist unstarred", message: "Gist successfully unstarred!")
                    } else {
                        self.showResultAlert(title: "Ups...", message: "Could not unstar gist. Try again.")
                    }
                }
            }
            completion(true)
        }
        
        unstarAction.backgroundColor = .darkGray
        starAction.backgroundColor = .orange

        
        let actionConfig = UISwipeActionsConfiguration(actions: [unstarAction, starAction])
        return actionConfig
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}
