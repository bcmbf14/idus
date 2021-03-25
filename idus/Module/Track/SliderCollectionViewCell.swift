//
//  SliderCollectionViewCell.swift
//  idus
//
//  Created by jc.kim on 3/24/21.
//

import UIKit
import RxSwift

class SliderCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SliderCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    var disposeBag = DisposeBag()
    
    
    func setImage(_ url: String) {
        loadImage(from: url)
            .asDriver(onErrorJustReturn: UIImage(systemName: "photo"))
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func loadImage(from urlStr: String) -> Observable<UIImage?> {
        return Observable.create { emitter in
            guard let url = URL(string: urlStr) ?? nil else {
                print("Invalid URL")
                emitter.onNext(UIImage(systemName: "photo"))
                return Disposables.create()
            }
            
            let cacheKey = NSString(string: urlStr)
            
            if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                emitter.onNext(cachedImage)
                emitter.onCompleted()
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                guard let data = data,
                      let image = UIImage(data: data) else {
                    emitter.onNext(nil)
                    emitter.onCompleted()
                    return
                }
                
                ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                emitter.onNext(image)
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}
