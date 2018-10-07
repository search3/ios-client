//
//  LottieView.swift
//  Exponent
//
//  Created by Robert Maciej Pieta on 10/6/18.
//  Copyright © 2018 Robert Maciej Pieta. All rights reserved.
//

import Foundation
import Lottie

@IBDesignable
internal class LottieView: LOTAnimationView {
    @IBInspectable var animationName: String?
    @IBInspectable var autoPlay: Bool = true
    @IBInspectable var clearBackgroundColor: Bool = true
    
    @IBInspectable override var animationSpeed: CGFloat {
        get { return super.animationSpeed }
        set { super.animationSpeed = newValue }
    }
    
    @IBInspectable override var loopAnimation: Bool {
        get { return super.loopAnimation }
        set { super.loopAnimation = newValue }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize() {
        if let animationName = animationName {
            setAnimation(named: animationName)
        }

        if clearBackgroundColor {
            backgroundColor = superview?.backgroundColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if autoPlay { play() }
    }
    
    func restart() {
        animationProgress = 0
    }
    
    func playFromCurrentProgress(toProgress progress: Double) {
        play(
            fromProgress: animationProgress,
            toProgress: CGFloat(progress),
            withCompletion: nil
        )
    }
}
