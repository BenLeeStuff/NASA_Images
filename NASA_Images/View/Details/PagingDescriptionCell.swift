//
//  PagingDesctiptionCell.swift
//  NASA_Images
//
//  Created by Ben Lee on 8/1/23.
//

import UIKit

class PagingDescriptionCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "Title of the image here...", font: .boldSystemFont(ofSize: 18))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.constrainHeight(constant: 45)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. This is a placeholder text often used in design and typesetting to demonstrate the appearance of fonts, layouts, and visual elements without using actual content.", font: .boldSystemFont(ofSize: 14))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let descriptionTextView: UITextView = {
      let textView = UITextView()
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. This is a placeholder text often used in design and typesetting to demonstrate the appearance of fonts, layouts, and visual elements without using actual content."
        textView.font = .systemFont(ofSize: 19)
        textView.backgroundColor = .red
        textView.isScrollEnabled = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
