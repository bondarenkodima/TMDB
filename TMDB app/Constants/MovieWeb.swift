//
//  MovieWeb.swift
//  TMDB app
//
//  Created by MacBook Pro on 03.01.2023.

//MARK: - Frameworks
import Foundation

//MARK: - Movie Constants
struct MovieConstants {
    static let baseURL = "https://api.themoviedb.org/3"
    static let type = "movie"
    static let apiKey = "api_key=28df62535a87e62fff4f3f08261901ef"
    static let firstPage = "page=1"
    static let baseImageURL = "https://image.tmdb.org/t/p/w500"
    
    struct Category {
        static let nowPlaying = "now_playing"
        static let popular = "popular"
        static let topRated = "top_rated"
        static let upcoming = "upcoming"
    }
}

//MARK: - URL Address
struct URLAddressMovie {
    let urlNowPlaying = "\(MovieConstants.baseURL)/\(MovieConstants.type)/\(MovieConstants.Category.nowPlaying)?\(MovieConstants.apiKey)&\(MovieConstants.firstPage)"
    let urlPopular = "\(MovieConstants.baseURL)/\(MovieConstants.type)/\(MovieConstants.Category.popular)?\(MovieConstants.apiKey)&\(MovieConstants.firstPage)"
    let urlTopRated = "\(MovieConstants.baseURL)/\(MovieConstants.type)/\(MovieConstants.Category.topRated)?\(MovieConstants.apiKey)&\(MovieConstants.firstPage)"
    let urlUpcoming = "\(MovieConstants.baseURL)/\(MovieConstants.type)/\(MovieConstants.Category.upcoming)?\(MovieConstants.apiKey)&\(MovieConstants.firstPage)"  
    let discoverURL = "\(MovieConstants.baseURL)/discover/\(MovieConstants.type)?\(MovieConstants.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&\(MovieConstants.firstPage)&with_watch_monetization_types=flatrate"
    let searchQueryURL = "\(MovieConstants.baseURL)/search/\(MovieConstants.type)?\(MovieConstants.apiKey)&query="
    let genreData = "\(MovieConstants.baseURL)/genre/\(MovieConstants.type)/list?\(MovieConstants.apiKey)&language=en-US"
}
