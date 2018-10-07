//
//  StoryboardExtensions.swift
//  Exponent
//
//  Created by Robert Maciej Pieta on 10/6/18.
//  Copyright © 2018 Robert Maciej Pieta. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    static func instantiate<T: Identifiable>(_ type: T.Type) -> T {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let viewController = storyboard.instantiateViewController(withIdentifier: T.identifier) as? T else {
            fatalError("invalid configuration")
        }
        return viewController
    }
}
