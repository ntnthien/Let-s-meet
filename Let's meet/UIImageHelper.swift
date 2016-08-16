//
//  UIImageHelper.swift
//
//  Created by Do Nguyen on 6/1/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

extension UIImage {
    
    var decompressedImage: UIImage {
        // Using CoreGraphic
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        drawAtPoint(CGPointZero)
        let decompressedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return decompressedImage
    }
    
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    /// Scale Image to new Size
    func scaleImage(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func createRadius(newSize: CGSize, radius: CGFloat, byRoundingCorners: UIRectCorner?) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let imgRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        if let roundingCorners = byRoundingCorners {
            UIBezierPath(roundedRect: imgRect, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: radius, height: radius)).addClip()
        } else {
            UIBezierPath(roundedRect: imgRect, cornerRadius: radius).addClip()
            
        }
        self.drawInRect(imgRect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}


