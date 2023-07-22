//
//  DetailsImageCell.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/19/23.
//

import UIKit

class DetailsImageCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "TITLE LABEL", font: .boldSystemFont(ofSize: 20))
        return label
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        return tv
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
