//
//  ImageDetailsController.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/17/23.
//

import UIKit

class DetailsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let pagingCollectionViewCellId = "pagingCollectionViewCellId"
    private let pagingDescriptionCellId = "pagingCollectionViewCellId"
    var imageGroup: (imageTitle: String, imageData: SearchItem)?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        
        //collectionView.isPagingEnabled = true
        //collectionView.contentInsetAdjustmentBehavior = .never

        self.collectionView!.register(PagingCollectionViewCell.self, forCellWithReuseIdentifier: pagingCollectionViewCellId)
        
        self.collectionView!.register(PagingDescriptionCell.self, forCellWithReuseIdentifier: pagingDescriptionCellId)
    }
    
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.collectionView.frame.width, height: 400)
    }
    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2
//    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pagingCollectionViewCellId, for: indexPath) as! PagingCollectionViewCell
            if let group = imageGroup {
                cell.imageGroup = group
            }

            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pagingDescriptionCellId, for: indexPath) as! PagingDescriptionCell
            return cell
        default:
            return UICollectionViewCell()
        }
 
        
//        guard let group = imageGroup else {return cell}
//
//        let imageData = group.imageData.data[indexPath.item]
//        let nasa_id = imageData.nasa_id
//
//        let imageURLString = "https://images-assets.nasa.gov/image/\(nasa_id)/\(nasa_id)~medium.jpg"
//
//        print("imageURLString = \(imageURLString)")
//        print("Nasa ID: \(nasa_id)")
//
//        guard let imageURL = URL(string: imageURLString) else {
//            print("Invalid URL in details controller for cell")
//            return cell
//        }
//        cell.imageView.sd_setImage(with: imageURL)
//        cell.titleLabel.text = imageData.title
//        cell.descriptionTextView.text = imageData.description
        
        //return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("item: \(indexPath.item), section: \(indexPath.section), row: \(indexPath.row)")
    }
    
    init(imageGroup: (imageTitle: String, imageData: SearchItem)) {
        self.imageGroup = imageGroup
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
