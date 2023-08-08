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
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title of image..."
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.constrainHeight(constant: 50)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = VerticalStackView(arrangedSubviews: [imageView, titleLabel])
        addSubview(stackView)
        stackView.fillSuperview()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

