//
//  SearchResult.swift
//  MovieGuide
//
//  Created by Kairat Yelubay on 24.05.2022.
//

import Foundation

struct ResultArray: Codable {
    let results: [SearchResult]
}

struct SearchResult: Codable {
    let title: String
    let originalTitle: String
    let posterPath: String?
    let releaseYear: String
    let voteAverage: Double
    let overview: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseYear = "release_date"
        case voteAverage = "vote_average"
        case overview
    }

    var poster: String {
        return posterPath ?? ""
    }

    var rating: String {
        return String(voteAverage)
    }
    
    var movieOverview: String {
        return overview ?? ""
    }
}
