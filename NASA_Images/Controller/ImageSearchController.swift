//
//  ImageSearchController.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/9/23.
//

import UIKit

private let reuseIdentifier = "Cell"

class ImageSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate var searchItems = [SearchItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(SearchResultsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.fetchMedia()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchResultsCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (view.frame.width/2) - 20, height: 320)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func fetchMedia() {
        Service.shared.fetchMedia(searchTerm: "Apollo 11") { searchItems, err in
            if let err = err {
                print("Failed to fetch media, ", err)
                return
            }
            self.searchItems = searchItems
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            print("Finished fetching images from ImageSearchController")
            self.printSearchResults()
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

    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
