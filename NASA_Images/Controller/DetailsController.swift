//
//  ImageDetailsController.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/17/23.
//

import UIKit

private let reuseIdentifier = "DetailsImageCell"

class DetailsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var imageGroup: (imageTitle: String, imageData: SearchItem)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(DetailsImageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.backgroundColor = .orange
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageGroup?.imageData.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.collectionView.frame.width, height: self.collectionView.frame.height * 2)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DetailsImageCell
    
        cell.backgroundColor = .systemBlue
        return cell
    }
    
    init(imageGroup: (imageTitle: String, imageData: SearchItem)) {
        self.imageGroup = imageGroup
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
