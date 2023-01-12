//
//  MovieDetailsData.swift
//  TMDB app
//
//  Created by MacBook Pro on 03.01.2023.

//MARK: - Frameworks
import Foundation

//MARK: - Movie Details Data
struct MovieDetailsData : Codable{
    let id: Int?
    let imdb_id, homepage: String?
    let original_title, overview: String?
    let title: String?
    let popularity: Double?
    let poster_path: String?
    let release_date: String?
    let vote_average: Double?
    let vote_count: Int?
}
