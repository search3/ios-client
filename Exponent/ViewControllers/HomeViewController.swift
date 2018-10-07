//
//  ViewController.swift
//  Exponent
//
//  Created by Robert Maciej Pieta on 10/6/18.
//  Copyright © 2018 Robert Maciej Pieta. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func start() {
        let qrViewController = UIStoryboard.instantiate(UploadViewController.self)
        self.navigationController?.pushViewController(qrViewController, animated: true)
    }
}
