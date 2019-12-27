//
//  UIImage+Ext.swift
//  aaaa
//
//  Created by Horacio Guzman on 11/20/18.
//  Copyright © 2018 Horacio Guzman. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    func resizeImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    func _64baseEncoded()->String{
        let representation = self.pngData()
        return (representation?.base64EncodedString(options: .endLineWithCarriageReturn))!
    }
}
