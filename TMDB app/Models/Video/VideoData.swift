//
//  VideoData.swift
//  TMDB app
//
//  Created by MacBook Pro on 27.12.2022.

//MARK: - Frameworks
import Foundation

//MARK: - Video Data
struct VideoData : Codable {
    let results : [VideoResults]?
}

//MARK: - Video Results
struct VideoResults : Codable {
    let key : String?
}
