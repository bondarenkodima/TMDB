//
//  MovieViewController.swift
//  TMDB app
//
//  Created by MacBook Pro on 03.01.2023.

//MARK: - Frameworks
import UIKit

// MARK: - Table View секции фильма
enum SectionsMovie: Int {
    case nowPlaying = 0
    case popular = 1
    case topRated = 2
    case upcoming = 3
}

// MARK: - View Controller фильмы
class MovieViewController: UIViewController {
    
    //MARK: - аутлет Table View фильмы
    @IBOutlet weak var movieTableView: UITableView!
    
    //MARK: - объекты
    let sectionTitles = ["NOW PLAYING", "POPULAR", "TOP RATED", "UPCOMING"]
    var tableViewCell = MovieTableViewCell()
    var movieManager = MovieManager()
    var viewModel : DetailMovieModel?
    private var genreData : [Genre]? = [Genre]()
    
    //MARK: - жизненый цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        movieTableView.dataSource = self
        movieTableView.delegate = self
        fetchGenreData()
    }
    
    //MARK: - нажатие поиска
    @IBAction func searchButtonDidPress(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Segues.toSearchVC, sender: nil)
    }
    
    //MARK: - получение данных жанра
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
}

// MARK: - Table View DataSource
extension MovieViewController: UITableViewDataSource {
   
    //MARK: - номер секции
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
   
    //MARK: - кол-во рядов в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //MARK: - ячейка для строк категории
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = movieTableView.dequeueReusableCell(withIdentifier: TableViewCells.movieTableViewCell, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        switch indexPath.section {
        case SectionsMovie.nowPlaying.rawValue:
            self.movieManager.performRequest(url: URLAddressMovie().urlNowPlaying) { results in
                switch results{
                case.success(let movie):
                    cell.configure(with: movie.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case SectionsMovie.popular.rawValue:
            self.movieManager.performRequest(url: URLAddressMovie().urlPopular) { results in
                switch results{
                case.success(let movie):
                    cell.configure(with: movie.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case SectionsMovie.topRated.rawValue:
            self.movieManager.performRequest(url: URLAddressMovie().urlTopRated) { results in
                switch results{
                case.success(let movie):
                    cell.configure(with: movie.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case SectionsMovie.upcoming.rawValue:
            self.movieManager.performRequest(url: URLAddressMovie().urlUpcoming) { results in
                switch results{
                case.success(let serie):
                    cell.configure(with: serie.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
}

// MARK: - Table View Delegate
extension MovieViewController: UITableViewDelegate{
    //MARK: - высота строк вьюхи
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 275
    }
    
    //MARK: - тайтл секций
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    //MARK: - высота заголовка в секции
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    //MARK: - настройки отображения вьюхи
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
    }
}

// MARK: - Movie Table View Cell Delegate
extension MovieViewController: MovieTableViewCellDelegate {
    //MARK: - переход во вьюшку с деталями
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toDetailVC {
            let destinationVC = segue.destination as! MovieDetailViewController
            destinationVC.viewModel = self.viewModel
            destinationVC.genreData = self.genreData
        }
    }
    
    //MARK: - обновление View Controller
    func updateViewController(_ cell: MovieTableViewCell, model: DetailMovieModel) {
        DispatchQueue.main.async {
            self.viewModel = model
            self.performSegue(withIdentifier: Segues.toDetailVC, sender: nil)
        }
    }
}
