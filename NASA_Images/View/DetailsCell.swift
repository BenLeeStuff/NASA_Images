//
//  DetailsImageCell.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/19/23.
//

import UIKit

class DetailsCell: UICollectionViewCell {
    
    var imageGroup: (imageTitle: String, imageData: SearchItem)?
    
    let titleFont = UIFont.boldSystemFont(ofSize: 20)
    let descriptionFont = UIFont.systemFont(ofSize: 18)
    
    var searchResult: SearchResult? {
        didSet {
            guard let searchResult = searchResult else { return }
            let targetWidth = UIScreen.main.bounds.width
            let titleLabelHeight = self.estimatedHeightForLabel(text: searchResult.title, font: titleFont, width: targetWidth)
            let nasa_id = searchResult.nasa_id
            
            titleLabel.constrainHeight(constant: titleLabelHeight)
            titleLabel.text = searchResult.title
            
            let descriptionLabelHeight = self.estimatedHeightForLabel(text: searchResult.description, font: descriptionFont, width: targetWidth)
            descriptionLabel.constrainHeight(constant: descriptionLabelHeight)
            descriptionLabel.text = searchResult.description
            
            let imageHeight = Service.shared.estimatedImageHeightForResult(searchResult: searchResult)
            imageView.constrainHeight(constant: imageHeight)
        }
    }
    
    private let pagingCellID = "pagingCellID"
    
    let numberLabel: UILabel = {
       let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .white.withAlphaComponent(0.95)
        label.textAlignment = .right
        label.constrainHeight(constant: 20)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        label.layer.shadowRadius = 10.0
        label.layer.shadowOpacity = 0.8
        return label
    }()
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isScrollEnabled = true
        sv.showsVerticalScrollIndicator = true
        sv.showsHorizontalScrollIndicator = false
       return sv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.constrainWidth(constant: UIScreen.main.bounds.width - 40)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.constrainWidth(constant: UIScreen.main.bounds.width - 40)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        titleLabel.font = titleFont
        descriptionLabel.font = descriptionFont
        
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        let textStackView = VerticalStackView(arrangedSubviews: [titleLabel, descriptionLabel], spacing: 15)
        textStackView.constrainWidth(constant: frame.width - 40)
       
        let stackView = VerticalStackView(arrangedSubviews: [imageView, textStackView], spacing: 15)
        stackView.alignment = .center
        
        scrollView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0).isActive = true
    }
    
    func estimatedHeightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        let boundingRect = attributedText.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                      options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                      context: nil)
        return ceil(boundingRect.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


