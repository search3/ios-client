//
//  QRViewController.swift
//  Exponent
//
//  Created by Robert Maciej Pieta on 10/6/18.
//  Copyright © 2018 Robert Maciej Pieta. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class UploadViewController: BaseViewController {
    var controller: ImageProcessingController?
    
    @IBAction func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func process(image: UIImage?) {
        guard let image = image else { return }
        
        controller = ImageProcessingController(image: image)
        
        let loadingViewController = UIStoryboard.instantiate(LoadingViewController.self)
        self.navigationController?.pushViewController(loadingViewController, animated: true)
        
        controller?.start(completion: { success, image in
            DispatchQueue.main.async {
//                if !success {
//                    let alert = UIAlertController(title: "Uh oh", message: "Did not process successfully", preferredStyle: .alert)
//                    self.present(alert, animated: true, completion: nil)
//                }
//                else {
                let completeViewController = UIStoryboard.instantiate(CompleteViewController.self)
               completeViewController.image = image

            self.navigationController?.pushViewController(completeViewController, animated: true)
//                }
            }
        })
    }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //let image = info[.originalImage] as? UIImage
        let image = UIImage(named: "IMG_8051.JPG")
    
        picker.dismiss(animated: true, completion: {
            self.process(image: image)
        })
    }
}
