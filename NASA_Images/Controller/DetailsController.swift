//
//  ImageDetailsController.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/17/23.
//

import UIKit

class DetailsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let detailsCellId = "detailsCellId"
    
    private let pagingCollectionViewCellId = "pagingCollectionViewCellId"
    private let pagingDescriptionCellId = "pagingCollectionViewCellId"
    
    var imageGroup: (imageTitle: String, imageData: SearchItem)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        self.collectionView.isPagingEnabled = true
        self.collectionView.register(DetailsCell.self, forCellWithReuseIdentifier: detailsCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageGroup?.imageData.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailsCellId, for: indexPath) as! DetailsCell
        
        guard let group = imageGroup else {
            return cell}
        let imageData = group.imageData.data[indexPath.item]
        let nasa_id = imageData.nasa_id
        let urlString = "https://images-assets.nasa.gov/image/\(nasa_id)/\(nasa_id)~thumb.jpg"

        guard let imageURL = URL(string: urlString) else {
            print("Invalid URL with: \(urlString)")
            return cell
        }
        cell.numberLabel.text = "\(indexPath.item + 1)/\(group.imageData.data.count)"
        cell.imageView.sd_setImage(with: imageURL)
        
        cell.searchResult = imageData
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let group = imageGroup {
            let imageData = group.imageData.data[indexPath.item]
            print(imageData.nasa_id)
        }
    }
    
    init(imageGroup: (imageTitle: String, imageData: SearchItem)) {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.imageGroup = imageGroup
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
