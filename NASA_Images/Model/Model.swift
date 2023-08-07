//
//  Model.swift
//  NASA_Images
//
//  Created by Ben Lee on 7/11/23.
//

import Foundation

struct SearchResponse: Codable {
    let collection: SearchCollection
}

struct SearchCollection: Codable {
    let version: String
    let href: String
    let items: [SearchItem]
}

struct SearchItem: Codable {
    let href: String
    var height: CGFloat?
    var data: [SearchResult]
    var links: [SearchResultLink]?
}

struct SearchResult: Codable {
    var album: [String]?
    let title: String
    let keywords: [String]
    let nasa_id: String
    let media_type: String
    let description: String
}

struct SearchResultLink: Codable {
    var href: String?
    var rel: String?
    var render: String?
}

struct ManifestCollectionResponse: Codable {
    let collection: ManifestCollection
}

struct ManifestCollection: Codable {
    let version: String
    let href: String
    var items: [ManifestItem]
}

struct ManifestItem: Codable {
    var href: String
}

struct ImageData {
    var href: String
    var estimatedHeight: CGFloat
}
