//
//  MovieTableViewCell.swift
//  TMDB app
//
//  Created by MacBook Pro on 03.01.2023.

//MARK: - Frameworks
import UIKit
import Kingfisher

// MARK: - Movie Table View Cell
class MovieTableViewCell: UITableViewCell {

    //MARK: - аутлет
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - объекты
    weak var delegate : MovieTableViewCellDelegate?
    private var movieArray : [Movie]? = [Movie]()
    var viewModel : DetailMovieModel?
    private var genreData : [Genre]? = [Genre]()
    
    //MARK: - жизненный цикл
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchGenreData()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - перезагрузка
    public func configure(with movie: [Movie]?){
        self.movieArray = movie
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    //получение данных жанра
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
}

// MARK: - Collection View Data Source
extension MovieTableViewCell: UICollectionViewDataSource {
    //MARK: - кол-во элементов в секции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArray?.count ?? 0
    }
    //MARK: - ячейка для элемента
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCells.nowPlayingCell, for: indexPath) as? MovieCollectionViewCell
        else {
            return UICollectionViewCell() }
        
        cell.posterLabel.text = self.movieArray?[indexPath.row].title ?? self.movieArray?[indexPath.row].original_title
        cell.posterImage.layer.cornerRadius = cell.posterImage.frame.size.height * 0.08

        if let posterPath = self.movieArray?[indexPath.row].poster_path{
            let downloadPosterImage = URL(string: "\(MovieConstants.baseImageURL)\(posterPath)")
            cell.posterImage.kf.setImage(with: downloadPosterImage)
        }
        return cell
    }
}

// MARK: - Collection View Delegate
extension MovieTableViewCell: UICollectionViewDelegate {
    //MARK: - проверка получения данных выбран ли элемент
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let title = movieArray?[indexPath.row].title ?? movieArray?[indexPath.row].original_title ?? ""
        let posterURL = movieArray?[indexPath.row].poster_path ?? ""
        let overview = movieArray?[indexPath.row].overview ?? ""
        let releaseDate = movieArray?[indexPath.row].release_date ?? ""
        let movieId = movieArray?[indexPath.row].id ?? 0
        let voteAverage = movieArray?[indexPath.row].vote_average ?? 0
        let voteCount = movieArray?[indexPath.row].vote_count ?? 0
        
        guard let movieGenreArray = movieArray?[indexPath.row].genre_ids else { return }
        let movieGenreCount = movieGenreArray.count
        
        guard let genreDataCount = self.genreData?.count else { return }
        
        var genreResult : String = ""
        
        for movieGenreIndex in 0...movieGenreCount - 1 {
            for gDataIndex in 0...genreDataCount - 1 {
                if movieGenreArray[movieGenreIndex] == self.genreData?[gDataIndex].id{
                    guard let genreName = self.genreData?[gDataIndex].name else { return }
                    genreResult = genreResult + genreName + ", "
                }
            }
        }
        self.viewModel = DetailMovieModel(movieTitle: title, posterURL: posterURL, overview: overview, releaseDate: releaseDate, id: movieId, voteAverage: voteAverage, voteCount: voteCount, genre: genreResult)

        self.delegate?.updateViewController(self, model: self.viewModel!)
    }
}
