//
//  SerieManager.swift
//  TMDB app
//
//  Created by MacBook Pro on 27.12.2022.

//MARK: - Frameworks
import Foundation

//MARK: - Serie Manager
struct SerieManager {

    //MARK: - получение сериала
    func performRequest(url: String, completion: @escaping (Result<SerieData, Error>) -> Void){
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
                        let series = try decoder.decode(SerieData.self, from: data)
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
    func fetchSearchQuery(with query: String, url: String, completion: @escaping (Result<SerieData, Error>) -> Void){
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
                        let series = try decoder.decode(SerieData.self, from: data)
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

    //MARK: - получение данных о серии с помощью идентификатора
    func fetchSpecificSerie(with externalId: String, completion: @escaping (Result<ExternalIDSerieData, Error>) -> Void){
        let url = "\(SerieConstants.baseURL)/find/\(externalId)?\(SerieConstants.apiKey)&language=en-US&external_source=imdb_id"
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
                        let series = try decoder.decode(ExternalIDSerieData.self, from: data)
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
    
    //MARK: - получении деталей серии
    func fetchSerieDetails(serieID: Int, completion: @escaping (Result<SerieDetailsData, Error>) -> Void){
        let url = "\(SerieConstants.baseURL)/\(SerieConstants.type)/\(String(serieID))?\(SerieConstants.apiKey)&language=en-US"
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
                        let series = try decoder.decode(SerieDetailsData.self, from: data)
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
        if let urlString = URL(string: URLAddressSerie().genreData) {
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
    func fetchCast(serieID: Int, completion: @escaping (Result<CastData, Error>) -> Void){
        let url = "\(SerieConstants.baseURL)/\(SerieConstants.type)/\(String(serieID))/credits?\(SerieConstants.apiKey)&language=en-US"
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
    
    //MARK: - получение видео сериала
    func fetchVideos(serieID: Int, completion: @escaping (Result<VideoData, Error>) -> Void){
        let url = "\(SerieConstants.baseURL)/\(SerieConstants.type)/\(String(serieID))/videos?\(SerieConstants.apiKey)&language=en-US"
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
