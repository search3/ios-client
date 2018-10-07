//
//  Identifiable.swift
//  Exponent
//
//  Created by Robert Maciej Pieta on 10/6/18.
//  Copyright © 2018 Robert Maciej Pieta. All rights reserved.
//

import Foundation
import UIKit

internal protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: Identifiable { }
extension UIView: Identifiable { }
