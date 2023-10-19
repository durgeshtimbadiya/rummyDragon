//
//  UIImageView+Extension.swift
//  Lets Card
//
//  Created by Durgesh on 02/01/23.
//

import UIKit

@IBDesignable class RotatableImageView: UIImageView {
    @objc @IBInspectable var rotationDegrees: Float = 0 {
        didSet {
            let angle = NSNumber(value: rotationDegrees / 180.0 * Float.pi)
            layer.setValue(angle, forKeyPath: "transform.rotation.z")
        }
    }
}

extension UIImageView {
    func rotateWithAnimation(angle: CGFloat, duration: CGFloat? = nil) {
        let pathAnimation = CABasicAnimation(keyPath: "transform.rotation")
        pathAnimation.duration = CFTimeInterval(duration ?? 1.0)
        pathAnimation.fromValue = 0
        pathAnimation.toValue = angle
        pathAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        self.transform = transform.rotated(by: angle)
        self.layer.add(pathAnimation, forKey: "transform.rotation")
    }
}
