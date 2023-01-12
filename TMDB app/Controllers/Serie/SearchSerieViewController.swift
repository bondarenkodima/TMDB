//
//  SearchSerieViewController.swift
//  TMDB app
//
//  Created by MacBook Pro on 05.01.2023.

//MARK: - Frameworks
import UIKit
import Kingfisher

//MARK: - Search Serie View Controller
class SearchSerieViewController: UIViewController {
    
    //MARK: - аутлеты
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - объекты
    private var serieArray : [Serie]?
    private var selectedSerie : Serie?
    private var genreData : [Genre]? = [Genre]()
    
    //MARK: - жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchBar.delegate = self
        fetchDiscoverSerie()
        fetchGenreData()
    }
    
    //MARK: - получение сериала
    private func fetchDiscoverSerie(){
        SerieManager().performRequest(url: URLAddressSerie().discoverURL) { results in
            DispatchQueue.main.async { [weak self] in
                switch results{
                case.success(let serie):
                    self?.serieArray = serie.results
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.searchTableView.reloadData()
            }
        }
    }
    //получения данных жанра
    private func fetchGenreData(){
        SerieManager().fetchGenreData { results in
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
            let destinationVC = segue.destination as! SerieDetailViewController
            destinationVC.configureFromSearchVC(with: selectedSerie, and: self.genreData)
        }
    }
}

//MARK: - Table View Data Source
extension SearchSerieViewController: UITableViewDataSource{
    //MARK: - кол-во элементов в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serieArray?.count ?? 0
    }
    //MARK: - ячейка для элемента
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: TableViewCells.searchTableViewCell, for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let serie = self.serieArray?[indexPath.row]
        cell.serieTitle.text = serie?.name
        
        if let posterPath = serie?.posterPath{
            let downloadPosterImage = URL(string: "\(SerieConstants.baseImageURL)\(posterPath)")
            cell.posterImage.kf.setImage(with: downloadPosterImage)
        }
        
        if let voteAverage = serie?.voteAverage, let voteCount = serie?.voteCount {
            cell.scoreLabel.text = String(format:"%.1f", voteAverage) + " (\(String(voteCount)))"
        }
        return cell
    }
}

//MARK: - Table View Delegate
extension SearchSerieViewController: UITableViewDelegate {
    //MARK: - высота строк вьюхи
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    //MARK: - выбраная строка
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedSerie = self.serieArray?[indexPath.row].self
        self.performSegue(withIdentifier: Segues.searchToDetail, sender: nil)
    }
}

//MARK: - Search Bar Delegate
extension SearchSerieViewController: UISearchBarDelegate{
    //MARK: - изменение текста
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            let query = searchText
            SerieManager().fetchSearchQuery(with: query, url: URLAddressSerie().searchQueryURL) { results in
                DispatchQueue.main.async { [weak self] in
                    switch results{
                    case.success(let serie):
                        self?.serieArray = serie.results
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self?.searchTableView.reloadData()
                }
            }
        }
        else {
            self.fetchDiscoverSerie()
        }
    }
    //MARK: - нажата кнопка Cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.fetchDiscoverSerie()
    }
}
