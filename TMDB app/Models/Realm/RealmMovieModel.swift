//
//  RealmMovieModel.swift
//  TMDB app
//
//  Created by MacBook Pro on 09.01.2023.

//MARK: - Frameworks
import Foundation
import RealmSwift

//MARK: - Realm Movie Model
@objcMembers
class RealmMovieModel: Object {
    dynamic var id : Int?
    dynamic var movieID : String = ""
    dynamic var posterURL : String = ""
    dynamic var title : String = ""
    dynamic var date : String = ""
    dynamic var overview : String = ""
    dynamic  var score : String = ""
    
    init(id: Int? = nil, movieID: String, posterURL : String, title: String, date: String, overview: String, score: String) {
        self.id = id
        self.movieID = movieID
        self.posterURL = posterURL
        self.title = title
        self.date = date
        self.overview = overview
        self.score = score
    }
    override init() {
        super.init()
    }
}
