//
//  UIImage_Extension.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/3/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit


public enum MediaType {
    case Image
    case Video
    case File
}

extension UIImage {
    
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
        return result!
    }
}
