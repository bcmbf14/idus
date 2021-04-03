//
//  ImageCacheManager.swift
//  idus
//
//  Created by jc.kim on 3/25/21.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        /*
         print(cache.diskStorage.config)
         Config(sizeLimit: 0, expiration: Kingfisher.StorageExpiration.days(7), pathExtension: nil, usesHashedFileName: true, name: "default", fileManager: <NSFileManager: 0x60000105c8e0>, directory: nil, cachePathBlock: nil)
         */
        let cache = ImageCache.default
        cache.retrieveImage(forKey: urlString) { (result) in
            switch result {
            case .success(let value):
                if value.cacheType == .none {
                    let url = URL(string: urlString)
                    self.kf.setImage(with: url)
                }else {
                    self.image = value.image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
