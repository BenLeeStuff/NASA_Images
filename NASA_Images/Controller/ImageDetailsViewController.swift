//
//  ImageDetailsViewController.swift
//  NASA_Images
//
//  Created by Ben Lee on 8/2/23.
//

import UIKit

class ImageDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var imageData: [ImageData] = []
    
    var imageGroup: (imageTitle: String, imageData: SearchItem)?
//        didSet {
//            print("imageGroup did Set")
//
//            guard let imageGroup = imageGroup else {return}
//
            
            
//            for data in imageGroup.imageData.data {
//                let nasa_id = data.nasa_id
//                print("  ")
//                print("  ")
//                print("  ")
//                self.fetchImageData(nasa_id: nasa_id)
//                //print("manifest for nasa_id: \(nasa_id)")
////                Service.shared.fetchImageData(nasa_id: nasa_id) { imageData in
////                    print(" ")
////                    print("image href: ", imageData.href)
////                    //print("estimated height: ", imageData.estimatedHeight)
////                    print(" ")
////                }
//            }
            
//
//        }
//    }
    
    
    func fetchImageData(nasa_id: String) {
        let suffixes = ["large.jpg", "medium.jpg", "small.jpg"]
        
        var manifestItems: [ManifestItem]?
        var manifestItem: ManifestItem?
        var validHref: String?
        
        var imageData: ImageData?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.shared.fetchManifest(nasa_id: nasa_id) { manifestCollection in
            
            manifestItems = manifestCollection.items
            manifestItem = manifestItems?.first ?? manifestItems?.last
            validHref = manifestItem?.href
            imageData = ImageData(href: validHref ?? "", estimatedHeight: 100)
            dispatchGroup.leave()
        }
        //print("validHref: \(manifestItem?.href)")

        dispatchGroup.notify(queue: .main) {

            if let data = imageData {
                self.imageData.append(data)
                //print("OK   \(data.href)")
            } else {
                print("CANT  index: \(self.imageData.count - 1), href: \(self.imageData.last?.href)")
                
            }
            //self.pagingCollectionView.reloadData()
        }
    }
    
    let colors: [UIColor] = [.red, .green, .blue, .yellow]
    
    let pagingCellId = "pagingCellId"
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.isScrollEnabled = true
        sv.showsVerticalScrollIndicator = true
        sv.showsHorizontalScrollIndicator = false
       return sv
    }()
    
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
        cv.constrainHeight(constant: 450)
        return cv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(text: "Title of the image here...", font: .boldSystemFont(ofSize: 22))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.constrainHeight(constant: 45)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. This is a placeholder text often used in design and typesetting to demonstrate the appearance of fonts, layouts, and visual elements without using actual content.", font: .boldSystemFont(ofSize: 20))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.constrainHeight(constant: 900)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        pagingCollectionView.register(PagingImageCell.self, forCellWithReuseIdentifier: pagingCellId)
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        let stackView = VerticalStackView(arrangedSubviews: [pagingCollectionView, titleLabel, descriptionLabel])
        scrollView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 0).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = pagingCollectionView.dequeueReusableCell(withReuseIdentifier: pagingCellId, for: indexPath) as! PagingImageCell
        
        guard let group = imageGroup else {return cell}
        
        let imageData = group.imageData.data[indexPath.item]
        let nasa_id = imageData.nasa_id
        
        let imageURLString = "https://images-assets.nasa.gov/image/\(nasa_id)/\(nasa_id)~small.jpg"
        
        guard let imageURL = URL(string: imageURLString) else {
            print("Invalid URL in details controller for cell")
            return cell
        }
        
        cell.imageView.sd_setImage(with: imageURL)
        print("imageURLString = \(imageURLString)")
        print("Nasa ID: \(nasa_id)")
        
        //cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  imageGroup?.imageData.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: pagingCollectionView.frame.width, height: 450)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    init(imageGroup: (imageTitle: String, imageData: SearchItem)) {
        super.init(nibName: nil, bundle: nil)
        self.imageData.removeAll()
        self.imageGroup = imageGroup
        for data in imageGroup.imageData.data {
            let nasa_id = data.nasa_id
            print("  ")
            print("  ")
            print("  ")
            self.fetchImageData(nasa_id: nasa_id)

        }
        self.pagingCollectionView.reloadData()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(imageData.count, imageGroup?.imageData.data.count)
    }

}
