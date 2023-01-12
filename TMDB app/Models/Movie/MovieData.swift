//
//  MovieData.swift
//  TMDB app
//
//  Created by MacBook Pro on 03.01.2023.

//MARK: - Frameworks
import Foundation

// MARK: - Movie Data
struct MovieData: Codable {
    var results: [Movie]?
}

// MARK: - Movie
struct Movie: Codable {
    var adult: Bool?
    var backdrop_path: String?
    var id: Int?
    var genre_ids : [Int]?
    var original_title, overview: String?
    var popularity: Double?
    var poster_path, release_date, title: String?
    var video: Bool?
    var vote_average: Double?
    var vote_count: Int?

//    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case genreIDS = "genre_ids"
//        case id
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
//        case overview, popularity
//        case posterPath = "poster_path"
//        case releaseDate = "release_date"
//        case title, video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//    }
}

