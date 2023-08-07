//
//  DetailsImageCell.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/19/23.
//

import UIKit

class PagingCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var imageGroup: (imageTitle: String, imageData: SearchItem)?
    
    private let pagingCellID = "pagingCellID"
    
    lazy var pagingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.backgroundColor = .clear
        return cv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.constrainHeight(constant: 450)
        return iv
    }()
    
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
        
        pagingCollectionView.register(PagingImageCell.self, forCellWithReuseIdentifier: pagingCellID)
        
        addSubview(pagingCollectionView)
        pagingCollectionView.fillSuperview()
        
        //let stackView = VerticalStackView(arrangedSubviews: [imageView, titleLabel, descriptionTextView])

        //addSubview(stackView)
        //stackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pagingCollectionView.dequeueReusableCell(withReuseIdentifier: pagingCellID, for: indexPath) as! PagingImageCell
        
        guard let group = imageGroup else {return cell}
        
        let imageData = group.imageData.data[indexPath.item]
        let nasa_id = imageData.nasa_id
        
        let imageURLString = "https://images-assets.nasa.gov/image/\(nasa_id)/\(nasa_id)~medium.jpg"
        
        print("imageURLString = \(imageURLString)")
        print("Nasa ID: \(nasa_id)")
        
        guard let imageURL = URL(string: imageURLString) else {
            print("Invalid URL in details controller for cell")
            return cell
        }
        cell.imageView.sd_setImage(with: imageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageGroup?.imageData.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: pagingCollectionView.frame.width, height: 400)
    }
}


class DetailsTextCell: UICollectionViewCell {
    
    
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
        let stackView = VerticalStackView(arrangedSubviews: [titleLabel, textView])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
