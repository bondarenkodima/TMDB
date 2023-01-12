//
//  SearchMovieViewController.swift
//  TMDB app
//
//  Created by MacBook Pro on 05.01.2023.

//MARK: - Frameworks
import UIKit
import Kingfisher

//MARK: - Search Movie View Controller
class SearchMovieViewController: UIViewController {
    
    //MARK: - аутлеты
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - объекты
    private var movieArray : [Movie]?
    private var selectedMovie : Movie?
    private var genreData : [Genre]? = [Genre]()
    
    //MARK: - жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchBar.delegate = self
        fetchDiscoverMovies()
        fetchGenreData()
    }
    
    //MARK: - получение фильма
    private func fetchDiscoverMovies(){
        MovieManager().performRequest(url: URLAddressMovie().discoverURL) { results in
            DispatchQueue.main.async { [weak self] in
                switch results{
                case.success(let movie):
                    self?.movieArray = movie.results
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.searchTableView.reloadData()
            }
        }
    }
    //получения данных жанра
    private func fetchGenreData(){
        MovieManager().fetchGenreData { results in
            switch results{
            case.success(let genres):
                self.genreData = genres.genres
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //подготовка перехода
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.searchToDetail {
            let destinationVC = segue.destination as! MovieDetailViewController
            destinationVC.configureFromSearchVC(with: selectedMovie, and: self.genreData)
        }
    }
}

//MARK: - Table View Data Source
extension SearchMovieViewController: UITableViewDataSource{
    //MARK: - кол-во элементов в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieArray?.count ?? 0
    }
    //MARK: - ячейка для элемента
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: TableViewCells.searchTableViewCell, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = self.movieArray?[indexPath.row]
        cell.movieTitle.text = movie?.title
        
        if let posterPath = movie?.poster_path{
            let downloadPosterImage = URL(string: "\(MovieConstants.baseImageURL)\(posterPath)")
            cell.posterImage.kf.setImage(with: downloadPosterImage)
        }
        
        if let voteAverage = movie?.vote_average, let voteCount = movie?.vote_count {
            cell.scoreLabel.text = String(format:"%.1f", voteAverage) + " (\(String(voteCount)))"
        }
        return cell
    }
}

//MARK: - Table View Delegate
extension SearchMovieViewController: UITableViewDelegate {
    //MARK: - высота строк вьюхи
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    //MARK: - выбраная строка
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.selectedMovie = self.movieArray?[indexPath.row].self
        self.performSegue(withIdentifier: Segues.searchToDetail, sender: nil)
    }
}

//MARK: - Search Bar Delegate
extension SearchMovieViewController: UISearchBarDelegate{
    //MARK: - изменение текста
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            let query = searchText
            MovieManager().fetchSearchQuery(with: query, url: URLAddressMovie().searchQueryURL) { results in
                DispatchQueue.main.async { [weak self] in
                    switch results{
                    case.success(let movie):
                        self?.movieArray = movie.results
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self?.searchTableView.reloadData()
                }
            }
        }
        else {
            self.fetchDiscoverMovies()
        }
    }
    //MARK: - нажата кнопка Cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.fetchDiscoverMovies()
    }
}

