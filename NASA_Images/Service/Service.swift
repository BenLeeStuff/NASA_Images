//
//  Service.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/11/23.
//

import Foundation
import UIKit
// creating a class for the service layer.

class Service {
    static let shared = Service() // Singleton (Shared Intance)
    
    var imageHeight: CGFloat = 0
    var imageGroups = [(imageTitle: String, imageData: SearchItem)]()
    
    func fetchImages(searchTerm: String, completion: @escaping ([(imageTitle: String, imageData: SearchItem)], Error?) -> ()) {
        
        // This reformats the search term to handle spaces.
        let term = searchTerm.replacingOccurrences(of: " ", with: "%20")
        print("Fetching media from the service layer.")

        let urlString = "https://images-api.nasa.gov/search?q=\(term)"
        guard let url = URL(string: urlString) else {
            print("Error: invaid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, err in
            if let err = err {
                print("ERROR: Failed to fetch media: \(err)")
            } else {
                guard let data = data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    let searchResponse = try decoder.decode(SearchResponse.self, from: data)
                    
                    // Need to filter the media to only include images because some results are videos
                    // I'm first getting the searchItems array, then filtering the array based on the searchData media_type being equal to "image"
                    let searchItems = searchResponse.collection.items
                    let filteredItems = searchItems.compactMap {searchItem in
                        let filteredData = searchItem.data.filter { searchData in
                            return searchData.media_type == "image"
                        }
                        
                        // using nil coalescing to handle the case where there are no links.
                        let links = searchItem.links ?? []
                        
                        // using nil coalescing to handle the case where there are no images.
                        return !filteredData.isEmpty ? SearchItem(href: searchItem.href ,data: searchItem.data, links: links): nil
                    }
                    
                    // Reorganize data by title
                    var resultsByTitleHolder: [(imageTitle: String, imageData: SearchItem)] = []
                    for item in filteredItems {
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
                    
                    // passing back the filtered and reorganized items
                    completion(resultsByTitleHolder, nil)
                    
                } catch let jsonErr {
                    print("Error failed to decode JSON: \(jsonErr.localizedDescription)")
                    completion([], jsonErr)
                }
            }
        }.resume()
    }
    
    func fetchHeight(targetWidth: CGFloat, urlString: String, completion: @escaping (CGFloat) -> ()) {
        guard let url = URL(string: urlString) else {
            print("Error: invaid URL from \(urlString)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("ERROR: Failed to fetch media: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            guard let image = UIImage(data: data) else {return}

            do {
                let aspectRatio = image.size.height / image.size.width
                let targetHeight = targetWidth * aspectRatio
                completion(targetHeight)
            }
        }.resume()
    }
    
    func estimatedImageHeightForResult(searchResult: SearchResult) -> CGFloat {
        let group = DispatchGroup()
        let targetWidth =  UIScreen.main.bounds.width
        let nasa_id = searchResult.nasa_id
        let urlString = "https://images-assets.nasa.gov/image/\(nasa_id)/\(nasa_id)~small.jpg"
        var imageHeight: CGFloat = 0.0
    
        guard let url = URL(string: urlString) else {
            return 0
        }
        
        group.enter()
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer {
                group.leave()
            }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let jsonData = data else { return}
            
            do {
                let decoder = JSONDecoder()
                guard let image = UIImage(data: jsonData) else {return}
                
                let aspectRatio = image.size.height / image.size.width
                imageHeight = targetWidth * aspectRatio
            }
        }.resume()
        
        group.wait()
        
        return imageHeight
    }
}

