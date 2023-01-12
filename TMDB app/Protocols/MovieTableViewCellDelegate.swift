//
//  MovieTableViewCellDelegate.swift
//  TMDB app
//
//  Created by MacBook Pro on 03.01.2023.

//MARK: - Frameworks
import Foundation

// MARK: - Movie Table View Cell Delegate
protocol MovieTableViewCellDelegate: AnyObject {
    func updateViewController(_ cell: MovieTableViewCell, model: DetailMovieModel)
}
