//
//  WatchlistViewController.swift
//  TMDB app
//
//  Created by MacBook Pro on 08.01.2023.

//MARK: - Frameworks
import UIKit
import Kingfisher
import RealmSwift

//MARK: - Watchlist View Controller
class WatchlistViewController: UIViewController {
    
    //MARK: - аутлеты
    @IBOutlet weak var watchlistTableView: UITableView!
    
    //MARK: - объекты
    var movieManager = MovieManager()
    var loadedMovies = [RealmMovieModel]()
    var viewModel : DetailMovieModel?
    private var movieArray : [Movie]? = [Movie]()
    private var genreData : [Genre]? = [Genre]()
    
    //MARK: - жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        watchlistTableView.dataSource = self
        watchlistTableView.delegate = self
        fetchMovieRealm()
        fetchGenreData()

    }
    //MARK: - получние фильма realm
    func fetchMovieRealm() {
        
    }
    
    //получение данных жанра
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
    //подготовка переход
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.watchlistToDetail {
            let destinationVC = segue.destination as! MovieDetailViewController
            destinationVC.configureFromWatchlist(with: movieArray, and: self.genreData)
        }
    }
}

//MARK: - Table View Data Source
extension WatchlistViewController: UITableViewDataSource{
    //MARK: - кол-во рядов в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.loadedMovies.count
    }
    //MARK: - ячейка для строки watchlist Table View
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = watchlistTableView.dequeueReusableCell(withIdentifier: TableViewCells.watchlistTableViewCell, for: indexPath) as? WatchlistTableViewCell else {
            return UITableViewCell()
        }
        cell.movieTitle.text = loadedMovies[indexPath.row].title
        cell.movieScore.text = loadedMovies[indexPath.row].score
        let posterURL = loadedMovies[indexPath.row].posterURL
        cell.movieImage.kf.setImage(with: URL(string: posterURL))

        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
                loadedMovies.remove(at: indexPath.row)
                self.watchlistTableView.reloadData()
        }
    }
}

//MARK: - Table View Delegate
extension WatchlistViewController: UITableViewDelegate{
    //MARK: - высота строк вьюхи
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    //MARK: - выбраная строка
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let externalID = loadedMovies[indexPath.row].movieID
        movieManager.fetchSpecificMovie(with: externalID) { result in
            switch result{
            case .success(let movie):
                DispatchQueue.main.async {
                    self.movieArray = movie.movie_results
                    self.performSegue(withIdentifier: Segues.watchlistToDetail, sender: nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
