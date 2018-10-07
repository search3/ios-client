//
//  CompleteViewController.swift
//  Exponent
//
//  Created by Robert Maciej Pieta on 10/6/18.
//  Copyright © 2018 Robert Maciej Pieta. All rights reserved.
//

import Foundation
import UIKit

class CompleteViewController: BaseViewController {
    @IBOutlet var imageView: UIImageView?
    var image: UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView?.image = image
    }
    
    @IBAction func contributeMoreEvidence() {
        navigationController?.popToRootViewController(animated: true)
    }
}

