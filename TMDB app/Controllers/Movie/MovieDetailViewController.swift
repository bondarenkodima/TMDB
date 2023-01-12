//
//  MovieDetailViewController.swift
//  TMDB app
//
//  Created by MacBook Pro on 03.01.2023.

//MARK: - Frameworks
import UIKit
import Kingfisher
import WebKit
import RealmSwift

//MARK: - Detail View Controller фильмы
class MovieDetailViewController: UIViewController {
    
    //MARK: - аутлеты
    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var movieScore: UILabel!
    @IBOutlet weak var trailerCollectionView: UICollectionView!
    @IBOutlet weak var addWatchlistButton: UIButton!
    
    //MARK: - объекты
    private var movieManager = MovieManager()
    private var movieID : String?
    private var id : Int?
    private var posterString : String?
    public var viewModel : DetailMovieModel?
    private var movieArray : [Movie]? = [Movie]()
    private var casts : [Cast]? = [Cast]()
    public var genreData : [Genre]? = [Genre]()
    private var videoData : [VideoResults]? = [VideoResults]()
    private var dataManager = DataManager()
    
    
    //MARK: - жизненый цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        castCollectionView.dataSource = self
        trailerCollectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDetails()
        loadVideos()
    }
    
    //MARK: - нажатие кнопки watchList
    @IBAction func watchListButtonPressed(_ sender: UIButton) {
                print("Watchlist button pressed.")
    }
    
    //MARK: - обновление вьюхи
    private func loadDetails(){
        //проверка получения данных
        if movieArray?.isEmpty == false {
            let title = movieArray?[0].title ?? movieArray?[0].original_title ?? ""
            let posterURL = movieArray?[0].poster_path ?? ""
            let overview = movieArray?[0].overview ?? ""
            let releaseDate = movieArray?[0].release_date ?? ""
            let movieId = movieArray?[0].id ?? 0
            let voteAverage = movieArray?[0].vote_average ?? 0
            let voteCount = movieArray?[0].vote_count ?? 0
            
            guard let movieGenreArray = movieArray?[0].genre_ids else { return }
            let movieGenreCount = movieGenreArray.count
            
            guard let genreDataCount = self.genreData?.count else { return }
            
            var genreResult : String = ""
            
            for movieGenreIndex in 0...movieGenreCount - 1{
                for gDataIndex in 0...genreDataCount - 1 {
                    if movieGenreArray[movieGenreIndex] == self.genreData?[gDataIndex].id{
                        guard let genreName = self.genreData?[gDataIndex].name else { return }
                        genreResult = genreResult + genreName + ", "
                    }
                }
            }
            
            self.viewModel = DetailMovieModel(movieTitle: title, posterURL: posterURL, overview: overview, releaseDate: releaseDate, id: movieId, voteAverage: voteAverage, voteCount: voteCount, genre: genreResult)
        }
        //получение данных
        movieTitle.text = viewModel?.movieTitle
        movieYear.text = viewModel?.dateAndGenre
        movieScore.text = viewModel?.score
        movieOverview.text = viewModel?.overview
        posterImage.kf.setImage(with: viewModel?.posterImage)
        posterString = "\(MovieConstants.baseImageURL)" + (viewModel?.posterURL ?? "")
        
        //получение идентификатора
        movieManager.fetchMovieDetails(movieID: viewModel?.id ?? 0) { results in
            switch results{
            case .success(let details):
                self.id = details.id
                self.movieID = details.imdb_id
            case .failure(let error):
                print(error)
            }
        }
        //получение casts
        movieManager.fetchCast(movieID: viewModel?.id ?? 0) { results in
            switch results{
            case.success(let cast):
                DispatchQueue.main.async {
                    self.casts = cast.cast
                    self.castCollectionView.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //загрузка видео фильма
    func loadVideos(){
        movieManager.fetchVideos(movieID: viewModel?.id ?? 0) { results in
            switch results {
            case.success(let video):
                DispatchQueue.main.async {
                    self.videoData = video.results
                    self.trailerCollectionView.reloadData()
                }
            case.failure( let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // 
    //
    //
    
    //получение данных WatchlistVC
    public func configureFromWatchlist(with movie: [Movie]?, and genre: [Genre]?){
        self.movieArray = movie
        self.genreData = genre
    }
    //получение данных SearchVC
    public func configureFromSearchVC(with movie : Movie?, and genre: [Genre]?){
        if let movie{
            self.movieArray?.append(movie)
            self.genreData = genre
        }
    }
}

//MARK: - Collection View
extension MovieDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == castCollectionView{
            return self.casts?.count ?? 0
        }
        else{
            return self.videoData?.count ?? 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == castCollectionView{
            guard let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCells.castCell, for: indexPath) as? CastCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.castName.text = self.casts?[indexPath.row].name ?? self.casts?[indexPath.row].original_name
            cell.castImage.layer.cornerRadius = cell.castImage.frame.size.height * 0.1
            
            if let posterPath = self.casts?[indexPath.row].profile_path{
                let downloadPosterImage = URL(string: "\(MovieConstants.baseImageURL)\(posterPath)")
                cell.castImage.kf.setImage(with: downloadPosterImage)
            }
            return cell
        }
        else{
            guard let cell = trailerCollectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCells.trailerCell, for: indexPath) as? TrailerCollectionViewCell else {
                return UICollectionViewCell()
            }
            guard let videoKey = self.videoData?[indexPath.row].key else {return UICollectionViewCell()}
            guard let url = URL(string: "https://www.youtube.com/embed/\(videoKey)") else {return UICollectionViewCell()}
            cell.trailerWebView.load(URLRequest(url: url))
            return cell
        }
    }
}

