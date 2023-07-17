//
//  Service.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/11/23.
//

import Foundation

// creating a class for the service layer.

class Service {
    static let shared = Service() // Singleton (Shared Intance)
    
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
    
   

}

