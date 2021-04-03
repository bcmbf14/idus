//
//  SliderCollectionViewCell.swift
//  idus
//
//  Created by jc.kim on 3/24/21.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SliderCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
