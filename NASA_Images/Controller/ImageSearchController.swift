//
//  ImageSearchController.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/9/23.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "Cell"

class ImageSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    fileprivate var searchItems = [SearchItem]()
    fileprivate var imageGroups = [(imageTitle: String, imageData: SearchItem)]()
    fileprivate let searchContoller = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchBar()
        self.collectionView!.register(SearchResultsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.fetchImages(searchTerm: "hubble")
    }
    
    func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchContoller
        navigationItem.hidesSearchBarWhenScrolling = false
        searchContoller.searchBar.delegate = self
    }
    
    var timer: Timer?

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        // need search throttling (delay)
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { (_) in
            Service.shared.fetchImages(searchTerm: searchText) { response, error in
                self.imageGroups = response
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageGroups.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultsCell
        
        let group = imageGroups[indexPath.item]
        let imageURL = URL(string: group.imageData.links?.first?.href ?? "none")
        cell.imageView.sd_setImage(with: imageURL)
        cell.titleLabel.text = group.imageTitle

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (view.frame.width/2) - 20
        return .init(width: cellWidth, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item Selected: \(indexPath.item)")
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
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
