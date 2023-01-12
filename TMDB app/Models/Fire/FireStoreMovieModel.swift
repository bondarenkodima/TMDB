//
//  FireStoreSerieModel.swift
//  TMDB app
//
//  Created by MacBook Pro on 27.12.2022.
//
//MARK: - Frameworks
import Foundation

//MARK: - Fire Store Movie Model
struct FStoreMovieModel {
    var id : Int?
    var movieID : String
    var posterURL : String
    var title : String
    var date : String
    var overview : String
    var score : String
    //var uuid : String

    init(id: Int? = nil, movieID:String, posterURL : String, title: String, date: String, overview: String, score: String) {
        self.id = id
        self.movieID = movieID
        self.posterURL = posterURL
        self.title = title
        self.date = date
        self.overview = overview
        self.score = score
       // self.uuid = uuid
    }
}
