//
//  DetailSerieModel.swift
//  TMDB app
//
//  Created by MacBook Pro on 27.12.2022.

//MARK: - Frameworks
import Foundation

//MARK: - Detail Serie Model
struct DetailSerieModel {
    let serieTitle: String
    let posterURL: String
    let overview: String
    let releaseDate: String
    let id : Int
    let voteAverage: Double
    let voteCount: Int
    let genre : String
    
    var score : String {
        return String(format:"%.1f", voteAverage) + " (\(String(voteCount)))"
    }
    var posterImage : URL? {
        return URL(string: "\(SerieConstants.baseImageURL)\(String(describing: posterURL))")
    }
    var dateAndGenre : String {
        return "\(releaseDate.dropLast(6))" + " | " + "\(genre.dropLast(2))"
    }
}
