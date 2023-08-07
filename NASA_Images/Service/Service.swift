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
    
    func fetchMedia(searchTerm: String, completion: @escaping ([SearchItem], Error?) -> ()) {
        
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
                
//                    let dataString = String(data: data, encoding: .utf8)
//                    print(dataString!)
                    
                    // need to filter the media to only include images because some results are videos
                    // Im first getting the searchItems array, then filtering the array based on the searchData media_type being equal to "image"
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
                    
                    
                    
                    
                    
                    // passing back the filtered items
                    completion(filteredItems, nil)
                    
                } catch let jsonErr {
                    print("Error failed to decode JSON: \(jsonErr.localizedDescription)")
                    completion([], jsonErr)
                }
            }
        }.resume()
    }
    
    
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
                
//                    let dataString = String(data: data, encoding: .utf8)
//                    print(dataString!)
                    
                    // need to filter the media to only include images because some results are videos
                    // Im first getting the searchItems array, then filtering the array based on the searchData media_type being equal to "image"
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
    
    func fetchImageHeight(targetWidth: CGFloat, urlString: String, completion: @escaping (CGFloat, Error?) -> ()) {
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
                    
                    guard let image = UIImage(data: data) else {return}
                    let aspectRatio = image.size.height / image.size.width
                    let targetHeight = targetWidth * aspectRatio
                    print("TargetHeight: \(targetHeight)")
                    completion(targetHeight, nil)
                    
                }
            }
        }.resume()
    }
    
    func fetchHeight(targetWidth: CGFloat, urlString: String) -> CGFloat {
        guard let url = URL(string: urlString) else {
            print("Error: invaid URL")
            return 0
        }
        //let dispatchGroup = DispatchGroup()

        //lazy var height = CGFloat()
        //dispatchGroup.enter()
        URLSession.shared.dataTask(with: url) { data, response, err in
            if let err = err {
                print("ERROR: Failed to fetch media: \(err)")
            } else {
                guard let data = data else { return }

                do {
                    guard let image = UIImage(data: data) else {return}
                    
                    let aspectRatio = image.size.height / image.size.width
                    let targetHeight = targetWidth * aspectRatio
                    print("TargetHeight: \(targetHeight)")
                    //dispatchGroup.leave()
                    self.imageHeight = targetHeight
                }
            }
        }.resume()
        print("urlString: \(urlString)")
        print("height: \(self.imageHeight)")
        return self.imageHeight
    }
    
    func fetchHeight(targetWidth: CGFloat, urlString: String, completion: @escaping (CGFloat) -> ()) {
        guard let url = URL(string: urlString) else {
            print("Error: invaid URL")
            return
        }
        //let dispatchGroup = DispatchGroup()
        //dispatchGroup.enter()
        URLSession.shared.dataTask(with: url) { data, response, err in
            if let err = err {
                print("ERROR: Failed to fetch media: \(err)")
            } else {
                guard let data = data else { return }

                do {
                    guard let image = UIImage(data: data) else {return}
                    
                    let aspectRatio = image.size.height / image.size.width
                    let targetHeight = targetWidth * aspectRatio
                    //print("TargetHeightt: \(targetHeight)")
                    //dispatchGroup.leave()
                    //self.imageHeight = targetHeight
                    completion(targetHeight)
                }
            }
        }.resume()
    }
    
    func estimatedHeightForResult(searchResult: SearchResult) -> CGFloat {
        let targetWidth =  UIScreen.main.bounds.width
        let nasa_id = searchResult.nasa_id
        let urlString = "https://images-assets.nasa.gov/image/\(nasa_id)/\(nasa_id)~small.jpg"
        
        var imageHeight: CGFloat = 0.0
        //var titleLabelHeight: CGFloat = 0.0
        //var descriptionLabelHeight: CGFloat = 0.0
        
        let group = DispatchGroup()
        
        // Make the URLSession data task to fetch JSON data
        guard let apiUrl = URL(string: urlString) else {
            // Handle invalid URL
            return 0.0 // Return a default value or handle the error case
        }
        
        let session = URLSession.shared
        group.enter() // Notify the group that a task has started
        let task = session.dataTask(with: apiUrl) { data, response, error in
            
            // Handle URLSession response and calculate height
            defer {
                group.leave() // Notify the group that the task has finished
            }
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Check if there's any data returned
            guard let jsonData = data else {
                print("No data received.")
                return
            }
            
            do {
                // Use JSONDecoder to decode the JSON data into a Swift object
                let decoder = JSONDecoder()
                guard let image = UIImage(data: jsonData) else {return}
                
                let aspectRatio = image.size.height / image.size.width
                imageHeight = targetWidth * aspectRatio
                
                //titleLabelHeight = self.estimatedHeightForLabel(text: searchResult.title, font: .boldSystemFont(ofSize: 18), width: targetWidth)
                //descriptionLabelHeight = self.estimatedHeightForLabel(text: searchResult.description, font: .boldSystemFont(ofSize: 14), width: targetWidth)
                
            }
        }
        
        // Start the data task
        task.resume()
        
        // Wait for the URLSession data task to finish before returning the calculated height
        group.wait()
        
        return imageHeight //+ titleLabelHeight + descriptionLabelHeight
    }
    
    //    func fetchManifest(nasa_id: String, completion: @escaping (ManifestCollection) -> ()) {
    //        let urlString =  "https://images-api.nasa.gov/asset/\(nasa_id)"
    //
    //        guard let url = URL(string: urlString) else {
    //            print("Error: invaid URL")
    //            return
    //        }
    //
    //        URLSession.shared.dataTask(with: url) { data, response, err in
    //            if let err = err {
    //                print("ERROR: Failed to fetch media: \(err)")
    //            } else {
    //                guard let data = data else { return }
    //
    //                let dataString = String(data: data, encoding: .utf8)
    //                print("  ")
    //                print(dataString)
    //                print("  ")
    //
    //                do {
    //                    let decoder = JSONDecoder()
    //                    let response = try decoder.decode(ManifestCollectionResponse.self, from: data)
    //                    let responseCollection = response.collection
    ////                    let responseCollectionItems = responseCollection.items
    ////                    for item in responseCollectionItems {
    ////                        print("ITEM Href: ", item.href)
    ////                    }
    //                    completion(responseCollection)
    //
    //                } catch let jsonErr {
    //                    print("Error failed to decode JSON: \(jsonErr)")
    //                }
    //            }
    //        }.resume()
    //    }
    //
    func fetchManifest(nasa_id: String, completion: @escaping (ManifestCollection) -> ()) {
        let urlString =  "https://images-api.nasa.gov/asset/\(nasa_id)"
        
        guard let url = URL(string: urlString) else {
            print("Error: invaid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, err in
            if let err = err {
                print("ERROR: Failed to fetch media: \(err)")
            } else {
                guard let data = data else { return }
                
                let dataString = String(data: data, encoding: .utf8)
                //                print("  ")
                //                print(dataString)
                //                print("  ")
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ManifestCollectionResponse.self, from: data)
                    let responseCollection = response.collection
                    //                    let responseCollectionItems = responseCollection.items
                    //                    for item in responseCollectionItems {
                    //                        print("ITEM Href: ", item.href)
                    //                    }
                    completion(responseCollection)
                    
                } catch let jsonErr {
                    print("Error failed to decode JSON: \(jsonErr)")
                }
            }
        }.resume()
    }
    
    func estimatedHeightForLabel(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
        let boundingRect = attributedText.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                      options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                      context: nil)
        return ceil(boundingRect.height)
    }
    
//    func estimatedTotalHeightForModel(dataModel: DataModel, titleFont: UIFont, descriptionFont: UIFont, labelWidth: CGFloat) -> CGFloat {
//        let titleHeight = estimatedHeightForLabel(text: dataModel.title, font: titleFont, width: labelWidth)
//        let descriptionHeight = estimatedHeightForLabel(text: dataModel.description, font: descriptionFont, width: labelWidth)
//
//        // You can add any spacing or padding between the two labels here
//        let spacingBetweenLabels: CGFloat = 8
//
//        let totalHeight = titleHeight + spacingBetweenLabels + descriptionHeight
//        return totalHeight
//    }

    
    
    //    var validHrefs: [String] = []
    
    
    //    func fetchImageData(nasa_id: String, completion: @escaping (ImageData) -> ()) {
    //        let dispatchGroup = DispatchGroup()
    //        let suffixes = ["large.jpg", "medium.jpg", "small.jpg"]
    //        var validHrefs: [String]?
    //
    //
    //        dispatchGroup.enter()
    //        self.fetchManifest(nasa_id: nasa_id) { manifestCollection in
    //            dispatchGroup.leave()
    //            //validHrefs.removeAll() // clear any existing hrefs
    //
    //            let manifestItems = manifestCollection.items
    //            // find an appropriate url
    //
    //            for item in manifestItems {
    ////                print("item.href: \(item.href)")
    //                for suffix in suffixes {
    //                    if item.href.hasSuffix(suffix) {
    ////                        print("Valid item.href; \(item.href)")
////                        validHrefs?.append(item.href)
//                        let imageData = ImageData(href: item.href, estimatedHeight: nil)
//                        break
//                        completion(imageData)
//                    }
//                }
//            }
//        }
//        
//        
//        
//        // need to get an estimated height
////        dispatchGroup.enter()
////        let targetWidth =  UIScreen.main.bounds.width
////        self.fetchHeight(targetWidth: targetWidth, urlString: validHrefs.first!) { targetHeight in
////            dispatchGroup.leave()
////            imageData.estimatedHeight = targetHeight
////            imageData.href = self.validHrefs.first!
////        }
//        
//
//        
//    }
    
   
    
    

    

}

