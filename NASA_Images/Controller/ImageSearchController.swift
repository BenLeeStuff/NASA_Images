//
//  ImageSearchController.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/9/23.
//

import UIKit
import SDWebImage
import CHTCollectionViewWaterfallLayout

private let reuseIdentifier = "Cell"

class ImageSearchController: UICollectionViewController,  UISearchBarDelegate, PinterestLayoutDelegate {
    
    fileprivate var searchItems = [SearchItem]()
    fileprivate var imageGroups = [(imageTitle: String, imageData: SearchItem)]()
    fileprivate let searchContoller = UISearchController(searchResultsController: nil)
    fileprivate var thumbnailImageHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
        }
        
        self.setupSearchBar()
        self.collectionView!.register(SearchResultsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.fetchResults(searchTerm: "Apollo 11")
    }

    func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchContoller
        navigationItem.hidesSearchBarWhenScrolling = false
        searchContoller.searchBar.delegate = self
    }
    
    var timer: Timer?

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.fetchResults(searchTerm: searchText)
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageGroups.count
    }

    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let group = imageGroups[indexPath.item]
        let imageHeight = group.imageData.height ?? 0
        
        return imageHeight
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultsCell
        let group = imageGroups[indexPath.item]
        let imageURL = URL(string: group.imageData.links?.first?.href ?? "none")

        cell.imageView.sd_setImage(with: imageURL)
        cell.titleLabel.text = group.imageTitle
        
        return cell
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageGroup = imageGroups[indexPath.item]
        let detailsController = DetailsController(imageGroup: imageGroup)

        present(detailsController, animated: true)
    }

    func fetchResults(searchTerm: String) {
        var imageGroups: [(imageTitle: String, imageData: SearchItem)]?
        let targetWidth = (self.collectionView.bounds.width/2) - 20
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchImages(searchTerm: searchTerm) { groups, error in
            var imgGroups = groups
            
            for index in 0..<groups.count {
                let group = groups[index]
                let title = group.imageTitle
                let size = CGSize(width: targetWidth, height: 1000)
                let estimatedFrame = NSString(string: title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)], context: nil)

                let estimatedTextHeight = estimatedFrame.height
                let urlString = groups[index].imageData.links?.first?.href ?? ""
                dispatchGroup.enter()
                Service.shared.fetchHeight(targetWidth: targetWidth, urlString: urlString) { targetHeight in
                    dispatchGroup.leave()
                    imgGroups[index].imageData.height = targetHeight + estimatedTextHeight
                    imageGroups = imgGroups
                }
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            if let groups = imageGroups {
                self.imageGroups = groups
            }
            
            self.collectionView.reloadData()
        }
    }

    init() {
        super.init(collectionViewLayout: PinterestLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
