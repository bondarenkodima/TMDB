//
//  SerieWeb.swift
//  TMDB app
//
//  Created by MacBook Pro on 27.12.2022.

//MARK: - Frameworks
import Foundation

//MARK: - Serie Constants
struct SerieConstants {
    static let baseURL = "https://api.themoviedb.org/3"
    static let type = "tv"
    static let apiKey = "api_key=28df62535a87e62fff4f3f08261901ef"
    static let firstPage = "page=1"
    static let baseImageURL = "https://image.tmdb.org/t/p/w500"
    
    struct Category {
        static let airingToday = "airing_today"
        static let onTheAir = "on_the_air"
        static let popular = "popular"
        static let topRated = "top_rated"
    }
}

//MARK: - URL Address
struct URLAddressSerie {
    let urlAiringToday = "\(SerieConstants.baseURL)/\(SerieConstants.type)/\(SerieConstants.Category.airingToday)?\(SerieConstants.apiKey)&\(SerieConstants.firstPage)"
    let urlOnTheAir = "\(SerieConstants.baseURL)/\(SerieConstants.type)/\(SerieConstants.Category.onTheAir)?\(SerieConstants.apiKey)&\(SerieConstants.firstPage)"
    let urlPopular = "\(SerieConstants.baseURL)/\(SerieConstants.type)/\(SerieConstants.Category.popular)?\(SerieConstants.apiKey)&\(SerieConstants.firstPage)"
    let urlTopRated = "\(SerieConstants.baseURL)/\(SerieConstants.type)/\(SerieConstants.Category.topRated)?\(SerieConstants.apiKey)&\(SerieConstants.firstPage)"
    let discoverURL = "\(SerieConstants.baseURL)/discover/\(SerieConstants.type)?\(SerieConstants.apiKey)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&\(SerieConstants.firstPage)&with_watch_monetization_types=flatrate"
    let searchQueryURL = "\(SerieConstants.baseURL)/search/\(SerieConstants.type)?\(SerieConstants.apiKey)&query="
    let genreData = "\(SerieConstants.baseURL)/genre/\(SerieConstants.type)/list?\(SerieConstants.apiKey)&language=en-US"
}
