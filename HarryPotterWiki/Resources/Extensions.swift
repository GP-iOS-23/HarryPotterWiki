//
//  Extensions.swift
//  HarryPotterWiki
//
//  Created by Глеб Поляков on 08.12.2024.
//

import Foundation
import UIKit
import CoreImage.CIFilterBuiltins

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}

extension UIImage {
    func blur() -> UIImage? {
        let image = CIImage(image: self)
        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = image
        blurFilter.radius = 5
        guard let outputImage = blurFilter.outputImage else { return nil }
        return UIImage(ciImage: outputImage)
    }
}

extension String {
    func upperCasedFirstLetter() -> String {
        prefix(1).uppercased() + dropFirst()
    }
    
    func createAttributedString(boldRange: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        let regularFont = UIFont.systemFont(ofSize: 18, weight: .regular)
        attributedString.addAttribute(.font, value: regularFont, range: NSRange(location: 0, length: self.count))
        
        let semiboldFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        let semiboldRange = (self as NSString).range(of: boldRange)
        attributedString.addAttribute(.font, value: semiboldFont, range: semiboldRange)
        
        return attributedString
    }
}

extension Substring {
    func uppercasedFirstLatter() -> Substring {
        prefix(1).uppercased() + dropFirst()
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(addArrangedSubview)
    }
}

extension UIView {
    func setupGradient(with colors: [UIColor], locations: [NSNumber]) {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach {
            $0.removeFromSuperlayer()
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}


