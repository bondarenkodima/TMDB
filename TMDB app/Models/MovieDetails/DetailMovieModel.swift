//
//  DetailMovieModel.swift
//  TMDB app
//
//  Created by MacBook Pro on 03.01.2023.

//MARK: - Frameworks
import Foundation

//MARK: - Detail Movie Model
struct DetailMovieModel {
    let movieTitle: String
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
        return URL(string: "\(MovieConstants.baseImageURL)\(String(describing: posterURL))")
    }
    var dateAndGenre : String {
        return "\(releaseDate.dropLast(6))" + " | " + "\(genre.dropLast(2))"
    }
}
