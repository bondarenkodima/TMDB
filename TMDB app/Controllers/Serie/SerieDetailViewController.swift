//
//  SerieDetailViewController.swift
//  TMDB app
//
//  Created by MacBook Pro on 27.12.2022.

//MARK: - Frameworks
import UIKit
import Kingfisher
import WebKit
import RealmSwift

//MARK: - Detail ViewController сериалы
class SerieDetailViewController: UIViewController {
    
    //MARK: - аутлеты
    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var serieOverview: UILabel!
    @IBOutlet weak var serieYear: UILabel!
    @IBOutlet weak var serieTitle: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var trailerCollectionView: UICollectionView!
    @IBOutlet weak var serieScore: UILabel!
    @IBOutlet weak var addWatchlistButton: UIButton!
    
    //MARK: - объекты
    private var serieManager = SerieManager()
    private var serieID : String?
    private var id : Int?
    private var posterString : String?
    public var viewModel : DetailSerieModel?
    private var serieArray : [Serie]? = [Serie]()
    private var casts : [Cast]? = [Cast]()
    public var genreData : [Genre]? = [Genre]()
    private var videoData : [VideoResults]? = [VideoResults]()
    
    
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
    
    //MARK: - Actions
    @IBAction func watchListButtonPressed(_ sender: UIButton) {
        print("Watchlist button pressed.")
    }
    
    
    //MARK: - обновление вьюхи
    private func loadDetails(){
        //проверка получения данных
        if serieArray?.isEmpty == false {
            let title = serieArray?[0].name ?? serieArray?[0].originalName ?? ""
            let posterURL = serieArray?[0].posterPath ?? ""
            let overview = serieArray?[0].overview ?? ""
            let releaseDate = serieArray?[0].firstAirDate ?? ""
            let serieId = serieArray?[0].id ?? 0
            let voteAverage = serieArray?[0].voteAverage ?? 0
            let voteCount = serieArray?[0].voteCount ?? 0
            
            guard let serieGenreArray = serieArray?[0].genreIDS else { return }
            let serieGenreCount = serieGenreArray.count
            
            guard let genreDataCount = self.genreData?.count else { return }
            
            var genreResult : String = ""
            
            for serieGenreIndex in 0...serieGenreCount - 1{
                for gDataIndex in 0...genreDataCount - 1 {
                    if serieGenreArray[serieGenreIndex] == self.genreData?[gDataIndex].id{
                        guard let genreName = self.genreData?[gDataIndex].name else { return }
                        genreResult = genreResult + genreName + ", "
                    }
                }
            }
            
            self.viewModel = DetailSerieModel(serieTitle: title, posterURL: posterURL, overview: overview, releaseDate: releaseDate, id: serieId, voteAverage: voteAverage, voteCount: voteCount, genre: genreResult)
        }
        //настройки отображения деталей
        serieTitle.text = viewModel?.serieTitle
        serieYear.text = viewModel?.dateAndGenre
        serieScore.text = viewModel?.score
        serieOverview.text = viewModel?.overview
        posterImage.kf.setImage(with: viewModel?.posterImage)
        posterString = "\(SerieConstants.baseImageURL)" + (viewModel?.posterURL ?? "")
        
        //получение идентификатора
        serieManager.fetchSerieDetails(serieID: viewModel?.id ?? 0) { results in
            switch results{
            case .success(let details):
                self.id = details.id
                self.serieID = details.imdb_id
            case .failure(let error):
                print(error)
            }
        }
        //получение casts
        serieManager.fetchCast(serieID: viewModel?.id ?? 0) { results in
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
    //загрузка видео сериала
    func loadVideos(){
        serieManager.fetchVideos(serieID: viewModel?.id ?? 0) { results in
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
    public func configureFromWatchlist(with serie: [Serie]?, and genre: [Genre]?){
        self.serieArray = serie
        self.genreData = genre
    }
    //получение данных SearchVC
    public func configureFromSearchVC(with serie : Serie?, and genre: [Genre]?){
        if let serie{
            self.serieArray?.append(serie)
            self.genreData = genre
        }
    }
}

//MARK: - Collection View
extension SerieDetailViewController: UICollectionViewDataSource{
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
                let downloadPosterImage = URL(string: "\(SerieConstants.baseImageURL)\(posterPath)")
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
