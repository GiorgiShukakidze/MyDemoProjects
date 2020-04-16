//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Giorgi Shukakidze on 12/02/19.
//  Copyright © 2019 Giorgi Shukakidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func askButtonPressed(_ sender: UIButton) {
        imageView.image = ballArray[Int.random(in: 0...4)]
    }
    
    let ballArray = [#imageLiteral(resourceName: "ball1.png"),#imageLiteral(resourceName: "ball2.png"),#imageLiteral(resourceName: "ball3.png"),#imageLiteral(resourceName: "ball4.png"),#imageLiteral(resourceName: "ball5.png")]

}

