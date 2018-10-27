//
//  ImageUtilities.swift
//  InstrumentsTutorial
//
//  Created by James Frost on 11/03/2015.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit

private let _sharedCache = ImageCache()

class ImageCache {
  var images = [String: UIImage]()
  
  class var sharedCache: ImageCache {
    return _sharedCache
  }
  
  func setImage(_ image: UIImage, forKey key: String) {
    images[key] = image
  }
  
  func imageForKey(_ key: String) -> UIImage? {
    return images[key]
  }
    
    init() {
        NotificationCenter.default.addObserver(
            forName: .UIApplicationDidReceiveMemoryWarning,
            object: nil, queue: .main) { notification in
                self.images.removeAll(keepingCapacity: false)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidReceiveMemoryWarning, object: nil)
    }
}

extension UIImage {
  func applyTonalFilter() -> UIImage? {
    let context = CIContext(options:nil)
    let filter = CIFilter(name:"CIPhotoEffectTonal")
    let input = CoreImage.CIImage(image: self)
    filter?.setValue(input, forKey: kCIInputImageKey)
    let outputImage = filter?.outputImage
    
    let outImage = context.createCGImage(outputImage!, from: outputImage!.extent)
    let returnImage = UIImage(cgImage: outImage!)
    return returnImage
  }
}
