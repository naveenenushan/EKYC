//
//  imageDropShadow.swift
//  nConnect
//
//  Created by Mac  on 27/03/19.
//  Copyright © 2019 Think. All rights reserved.
//

import UIKit

enum ImageCompressType {
    case session
    case timeline
}

extension UIImage {
    
    func wxCompress(type: ImageCompressType = .timeline) -> UIImage {
        let size = self.wxImageSize(type: type)
        let reImage = resizedImage(size: size)
        let data = reImage.jpegData(compressionQuality: 0.5)!
        return UIImage.init(data: data)!
    }
    
    private func wxImageSize(type: ImageCompressType) -> CGSize {
        var width = self.size.width
        var height = self.size.height
        
        var boundary: CGFloat = 1280
        
        guard width > boundary || height > boundary else {
            return CGSize(width: width, height: height)
        }
        
        let s = max(width, height) / min(width, height)
        if s <= 2 {
            let x = max(width, height) / boundary
            if width > height {
                width = boundary
                height = height / x
            } else {
                height = boundary
                width = width / x
            }
        } else {
            if min(width, height) >= boundary {
                boundary = type == .session ? 800 : 1280
                let x = min(width, height) / boundary
                if width < height {
                    width = boundary
                    height = height / x
                } else {
                    height = boundary
                    width = width / x
                }
            }
        }
        return CGSize(width: width, height: height)
    }
    
    private func resizedImage(size: CGSize) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        var newImage: UIImage!
        UIGraphicsBeginImageContext(newRect.size)
        newImage = UIImage(cgImage: self.cgImage!, scale: 1, orientation: self.imageOrientation)
        newImage.draw(in: newRect)
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}
