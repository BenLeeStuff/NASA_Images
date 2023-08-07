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
        self.fetch(searchTerm: "Apollo 11")

    }

    func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchContoller
        navigationItem.hidesSearchBarWhenScrolling = false
        searchContoller.searchBar.delegate = self
    }
    
    var timer: Timer?

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // need search throttling (delay)
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.fetch(searchTerm: searchText)
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
        
        print("Item Selected: \(indexPath.item)")
        print(imageGroup.imageData)
        print(" ")
        print(imageGroup.imageData.data.first?.nasa_id)
        
        let detailsController = DetailsController(imageGroup: imageGroup)
        present(detailsController, animated: true)

    }
    
    func fetchImages(searchTerm: String) {
        Service.shared.fetchImages(searchTerm: searchTerm) { groups, error in
            if let error = error {
                print("Failed to fetch media, ", error)
                return
            }
            self.imageGroups = groups
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            print("Finished fetching images from ImageSearchController")
        }
        
        //print("ImageGroupsCount: \(self.imageGroups.count)")
    }
    
    func fetch(searchTerm: String) {
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
                    //print("TargetHeightt: \(targetHeight)")
                    imgGroups[index].imageData.height = targetHeight + estimatedTextHeight
                    imageGroups = imgGroups
                }
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            print("Completed dispatch group task")
            
            if let groups = imageGroups {
                self.imageGroups = groups

                
            }
//            for group in self.imageGroups {
//                print("Height: \(group.imageData.height)")
//            }
            
            
            self.collectionView.reloadData()
        }
    }
    
    

    
    fileprivate func printSearchResults() {
        print("Total searchItems count: ",searchItems.count)

        for item in self.searchItems {
            print("------------------------------------")
            print("Item: ")
            print(" href: ", item.href)
            for data in item.data {
                print(" Data: ")
                if let album = data.album {
                    for albumName in album {
                        print("     album: ", albumName)
                    }
                }
                print("     title: ", data.title)
                print("     media_type: ", data.media_type)
                print("     nasa_id: ", data.nasa_id)
            }
            if let links = item.links {
                for link in links {
                    print(" Link: ")
                    print("     href: ", link.href ?? "none")
                    print("     rel: ", link.rel ?? "none")
                    print("     render: ", link.render ?? "none")
                }
            }
            print("------------------------------------")
        }
    }
    
    fileprivate func populateByTitle() {
        var resultsByTitleHolder: [(imageTitle: String, imageData: SearchItem)] = []

        for item in self.searchItems {
            for data in item.data {
                let title = data.title
                
                 //check if the key exists
                if let index = resultsByTitleHolder.firstIndex(where: {$0.imageTitle == title}) {
                    // key exists.
                    resultsByTitleHolder[index].imageData.data.append(data)
                    // append the data to the array
                } else {
                    // key doesnt exist.
                    resultsByTitleHolder.append((imageTitle: title, imageData: item))
                    // create a new entry
                }
            }
        }
        
        self.imageGroups = resultsByTitleHolder
       // self.printImageGroupData()
    }
    
    fileprivate func printImageGroupData() {
        for (key, value) in self.imageGroups {
            print("Search Item title: \(key)")
            print("Number of images: \(value.data.count)")
            print("Thumb Link: ", value.links?.first?.href)
            for data in value.data {
                print(" Title: ", data.title)
                print("  Nasa ID: \(data.nasa_id)")
            }
            print("")
        }
    }
    
    init() {
        super.init(collectionViewLayout: PinterestLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
