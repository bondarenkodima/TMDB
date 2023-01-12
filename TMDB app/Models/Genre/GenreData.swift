//
//  GenreData.swift
//  TMDB app
//
//  Created by MacBook Pro on 27.12.2022.

//MARK: - Frameworks
import Foundation

// MARK: - Genre Data
struct GenreData : Codable {
    let genres: [Genre]?
}

// MARK: - Genre
struct Genre : Codable {
    let id: Int?
    let name: String?
}
