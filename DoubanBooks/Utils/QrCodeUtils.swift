//
//  QrCodeUtils.swift
//  Movies
//
//  Created by 2017yd on 2019/9/28.
//  Copyright © 2019年 2017yd. All rights reserved.
//

import UIKit
class QrCodeUtils {
    // MARK: -传进去字符串,生成二维码图片
    
    class func createQRCodeImage(_ text: String) -> UIImage {
        // 创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        // 将text加入二维码
        filter?.setValue(text.data(using: String.Encoding.utf8), forKey: "inputMessage")
        // 取出生成的二维码（不清晰）
        if let outputImage = filter?.outputImage {
            // 生成清晰度更好的二维码
            let qrCodeImage = createHighDefinitionUIImage(outputImage, size: 300)
            // 如果有一个头像的话，将头像加入二维码中心
            return qrCodeImage
        }
        return UIImage()
    }
    
    // MARK: - 生成高清的UIImage
    
    class func createHighDefinitionUIImage(_ image: CIImage, size: CGFloat) -> UIImage {
        let integral: CGRect = image.extent.integral
        let proportion: CGFloat = min(size / integral.width, size / integral.height)
        
        let width = integral.width * proportion
        let height = integral.height * proportion
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(image, from: integral)!
        
        bitmapRef.interpolationQuality = CGInterpolationQuality.none
        bitmapRef.scaleBy(x: proportion, y: proportion)
        bitmapRef.draw(bitmapImage, in: integral)
        let image: CGImage = bitmapRef.makeImage()!
        return UIImage(cgImage: image)
    }
    
    class func recognizeQrCode(qrCodeImage: UIImage) -> String? {
        // 1. 创建过滤器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        
        // 2. 获取CIImage
        guard let ciImage = CIImage(image: qrCodeImage) else { return nil }
        
        // 3. 识别二维码
        guard let features = detector?.features(in: ciImage) else { return nil }
        
        guard (features.count) > 0 else { return nil }
        let feature = features.first as? CIQRCodeFeature
        return feature?.messageString
    }
}
