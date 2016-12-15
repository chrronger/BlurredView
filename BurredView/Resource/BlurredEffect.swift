//
//  BlurredEffect.swift
//  swift-owner
//
//  Created by 希 Guan on 2016/12/14.
//  Copyright © 2016年 sen. All rights reserved.
//

import UIKit
import Accelerate

class BlurredEffect: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        cofig()
    }
    
    func cofig() {
        let image = UIImage(data: UIImageJPEGRepresentation(getCurrentImage(), 1.0)!)
        let sImage = blurredImage(image!, 0.09)
        let imageView = UIImageView(frame: frame)
        imageView.image = sImage
        self.addSubview(imageView)
    }
    
    
    func getCurrentImage() -> UIImage {
        let window = UIApplication.shared.delegate?.window
        let controller = window??.rootViewController
        UIGraphicsBeginImageContext((controller?.view.bounds.size)!)
        controller?.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func blurredImage(_ image:UIImage,_ level:CGFloat) -> UIImage {
        var blur = level
        if blur < 0 || blur > 1 {
            blur = 0.5
        }
        var boxSize = Int(level * 100)
        boxSize = boxSize - (boxSize % 2) + 1
        let img = image.cgImage
        var inBuffer = vImage_Buffer()
        var outBuffer = vImage_Buffer()
        var pixelBuffer: UnsafeMutableRawPointer
        var error = vImage_Error()
        // 从CGImage中获取数据
        let inProvider = img!.dataProvider
        let inBitmapData = inProvider!.data
        
        // 设置从CGImage获取对象的属性
        inBuffer.width = UInt(img!.width)
        inBuffer.height = UInt(img!.height)
        inBuffer.rowBytes = img!.bytesPerRow
        inBuffer.data = UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(inBitmapData))
        pixelBuffer = malloc(img!.bytesPerRow * img!.height)
        
        outBuffer.data = pixelBuffer
        outBuffer.width = UInt(img!.width)
        outBuffer.height = UInt(img!.height)
        outBuffer.rowBytes = img!.bytesPerRow
        
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, UInt32(boxSize), UInt32(boxSize), nil, UInt32(kvImageEdgeExtend))
        if error != 0 {
            print("error from convolution \(error)")
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let ctx = CGContext(data: outBuffer.data, width: Int(outBuffer.width), height: Int(outBuffer.height), bitsPerComponent: 8, bytesPerRow: outBuffer.rowBytes, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        
        let imageRef = ctx!.makeImage()!
        let returnImage = UIImage(cgImage: imageRef)
        
        free(pixelBuffer)
        
        return returnImage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
