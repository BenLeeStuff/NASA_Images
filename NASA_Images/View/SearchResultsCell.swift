//
//  SearchResultsCell.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/9/23.
//

import UIKit

class SearchResultsCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .blue
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.setContentHuggingPriority(.defaultLow, for: .vertical)
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title of image..."
        label.font = .boldSystemFont(ofSize: 16)//.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.constrainHeight(constant: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = VerticalStackView(arrangedSubviews: [imageView, titleLabel])
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // Using For dynamic resizing.
//    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
//        return layoutAttributes
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

