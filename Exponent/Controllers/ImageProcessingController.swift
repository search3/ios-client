//
//  TensorflowController.swift
//  Exponent
//
//  Created by Robert Maciej Pieta on 10/7/18.
//  Copyright © 2018 Robert Maciej Pieta. All rights reserved.
//

import Foundation
import UIKit
import Vision

class ImageProcessingController {
    var image: UIImage
    var completion: ((Bool,UIImage) -> Void)?

    init(image: UIImage) {
        self.image = image
    }
    
    func start(completion: @escaping ((Bool,UIImage) -> Void)) {
        self.completion = completion
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.processImage()
        }
    }
    
    func processImage() {
        var orientation: CGImagePropertyOrientation
        
        switch image.imageOrientation {
        case .up:
            orientation = .up
        case .right:
            orientation = .right
        case .down:
            orientation = .down
        case .left:
            orientation = .left
        default:
            orientation = .up
        }
        
        let faceLandmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: self.handleFaceFeatures)
        let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, orientation: orientation ,options: [:])
        do {
            try requestHandler.perform([faceLandmarksRequest])
        } catch {
            print(error)
        }
    }
    
    func handleFaceFeatures(request: VNRequest, errror: Error?) {
        guard let observations = request.results as? [VNFaceObservation] else {
            fatalError("unexpected result type!")
        }
        
        for face in observations {
            let w = face.boundingBox.size.width * image.size.width
            let h = face.boundingBox.size.height * image.size.height
            let x = face.boundingBox.origin.x * image.size.width
            let y = (1 - face.boundingBox.origin.y) * image.size.height - h
            
            let faceRect = CGRect(x: x, y: y, width: w, height: h)
            
            UIGraphicsBeginImageContextWithOptions(faceRect.size, false, image.scale)
            image.draw(in: CGRect(x: -faceRect.origin.x, y: -faceRect.origin.y, width: image.size.width, height: image.size.height))
            
            let faceImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let scaledImage = resize(image: faceImage)
            upload(image: scaledImage, ogImage: faceImage)
            return
        }
    }
    
    func resize(image: UIImage?) -> UIImage? {
        guard let image = image else { return UIImage() }

        let rect = CGRect(x: 0, y: 0, width: 96, height: 96)
        UIGraphicsBeginImageContext(rect.size)
        
        image.draw(in: rect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    func data(fromImage image: UIImage) -> [UInt8] {
        let size = image.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = image.cgImage else { return [] }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return pixelData
    }
    
    func upload(image: UIImage?, ogImage: UIImage?) {
        guard let image = image else { return }
        
        let imageData = data(fromImage: image)
        
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "http://127.0.0.1:5000/process")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["image": imageData], options: [])
        
        let task = session.dataTask(with: request) { (data, response, error) in
            do {
                if let data = data {
                    let obj = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    
                    if let obj = obj {
                        self.completion?(obj["success"] as? Bool ?? false, ogImage ?? UIImage())
                    }
                    else {
                        self.completion?(false, ogImage ?? UIImage())
                    }
                }
                else {
                    self.completion?(false, ogImage ?? UIImage())
                }
            }
            catch {
                self.completion?(false, ogImage ?? UIImage())
            }
        }
        
        task.resume()
    }
}
