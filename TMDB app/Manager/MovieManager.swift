//
//  MovieManager.swift
//  TMDB app
//
//  Created by MacBook Pro on 03.01.2023.

//MARK: - Frameworks
import Foundation

//MARK: - Movie Manager
struct MovieManager {

    //MARK: - получение фильма
    func performRequest(url: String, completion: @escaping (Result<MovieData, Error>) -> Void){
        if let urlString = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, _, error in
                if let error {
                    print(error)
                    return
                }
                if let data {
                    do{
                        let decoder = JSONDecoder()
                        let series = try decoder.decode(MovieData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(series))
                        }
                    }catch{
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - поиск и запрос
    func fetchSearchQuery(with query: String, url: String, completion: @escaping (Result<MovieData, Error>) -> Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        if let urlString = URL(string: url + query) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, _, error in
                if let error {
                    print(error)
                    return
                }
                if let data {
                    do{
                        let decoder = JSONDecoder()
                        let series = try decoder.decode(MovieData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(series))
                        }
                    }catch{
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }

    //MARK: - получение данных о фильме с помощью идентификатора
    func fetchSpecificMovie(with externalId: String, completion: @escaping (Result<ExternalIDMovieData, Error>) -> Void){
        let url = "\(MovieConstants.baseURL)/find/\(externalId)?\(MovieConstants.apiKey)&language=en-US&external_source=imdb_id"
        if let urlString = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, _, error in
                if let error {
                    print(error)
                    return
                }
                if let data {
                    do{
                        let decoder = JSONDecoder()
                        let series = try decoder.decode(ExternalIDMovieData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(series))
                        }
                    }catch{
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - получении деталей фильма
    func fetchMovieDetails(movieID: Int, completion: @escaping (Result<MovieDetailsData, Error>) -> Void){
        let url = "\(MovieConstants.baseURL)/\(MovieConstants.type)/\(String(movieID))?\(MovieConstants.apiKey)&language=en-US"
        if let urlString = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, _, error in
                if let error {
                    print(error)
                    return
                }
                if let data {
                    do{
                        let decoder = JSONDecoder()
                        let series = try decoder.decode(MovieDetailsData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(series))
                        }
                    }catch{
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - получение данных жанра
    func fetchGenreData(completion: @escaping (Result<GenreData, Error>) -> Void){
        if let urlString = URL(string: URLAddressMovie().genreData) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, _, error in
                if let error {
                    print(error)
                    return
                }
                if let data {
                    do{
                        let decoder = JSONDecoder()
                        let genres = try decoder.decode(GenreData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(genres))
                        }
                    }catch{
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - получение Cast
    func fetchCast(movieID: Int, completion: @escaping (Result<CastData, Error>) -> Void){
        let url = "\(MovieConstants.baseURL)/\(MovieConstants.type)/\(String(movieID))/credits?\(MovieConstants.apiKey)&language=en-US"
        if let urlString = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, _, error in
                if let error {
                    print(error)
                    return
                }
                if let data {
                    do{
                        let decoder = JSONDecoder()
                        let casts = try decoder.decode(CastData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(casts))
                        }
                    }catch{
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    
    //MARK: - получение видео фильма
    func fetchVideos(movieID: Int, completion: @escaping (Result<VideoData, Error>) -> Void){
        let url = "\(MovieConstants.baseURL)/\(MovieConstants.type)/\(String(movieID))/videos?\(MovieConstants.apiKey)&language=en-US"
        if let urlString = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: urlString) { data, _, error in
                if let error {
                    print(error)
                    return
                }
                if let data {
                    do{
                        let decoder = JSONDecoder()
                        let videos = try decoder.decode(VideoData.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(videos))
                        }
                    }catch{
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
}
