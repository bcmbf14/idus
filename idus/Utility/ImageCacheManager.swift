//
//  ImageCacheManager.swift
//  idus
//
//  Created by jc.kim on 3/25/21.
//

import UIKit

class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
