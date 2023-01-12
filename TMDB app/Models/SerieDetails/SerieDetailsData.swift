//
//  SerieDetailsData.swift
//  TMDB app
//
//  Created by MacBook Pro on 27.12.2022.

//MARK: - Frameworks
import Foundation

//MARK: - Serie Details Data
struct SerieDetailsData : Codable{
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
