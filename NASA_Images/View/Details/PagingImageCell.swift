//
//  PagingImageCell.swift
//  NASA_Images
//
//  Created by Ben Lee on 8/1/23.
//

import UIKit

class PagingImageCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        //iv.constrainHeight(constant: 450)
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
