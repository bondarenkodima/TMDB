//
//  SerieTableViewCellDelegate.swift
//  TMDB app
//
//  Created by MacBook Pro on 27.12.2022.

//MARK: - Frameworks
import Foundation

// MARK: - Serie Table View Cell Delegate
protocol SerieTableViewCellDelegate: AnyObject {
    func updateViewController(_ cell: SerieTableViewCell, model: DetailSerieModel)
}
