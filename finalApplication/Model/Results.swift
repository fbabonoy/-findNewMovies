//
//  Results.swift
//  hw3Applocation
//
//  Created by fernando babonoyaba on 4/7/22.
//

import Foundation


struct Results: Codable {
    
//    let backdropPath: String?
    let originalTitle: String?
    let overview: String?
    let posterPath: String?
    let id: Int?
    
    
    enum CodingKeys: String, CodingKey {
//        case backdropPath = "backdrop_path"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case id
    }
}
