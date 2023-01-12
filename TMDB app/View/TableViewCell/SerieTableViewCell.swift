//
//  SerieTableViewCell.swift
//  TMDB app
//
//  Created by MacBook Pro on 27.12.2022.

//MARK: - Frameworks
import UIKit
import Kingfisher

// MARK: - Serie Table View Cell
class SerieTableViewCell: UITableViewCell {

    //MARK: - аутлет
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - объекты
    weak var delegate : SerieTableViewCellDelegate?
    private var serieArray : [Serie]? = [Serie]()
    var viewModel : DetailSerieModel?
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
    public func configure(with serie: [Serie]?){
        self.serieArray = serie
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

// MARK: - Collection View DataSource
extension SerieTableViewCell: UICollectionViewDataSource {
    //MARK: - кол-во элементов в секции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serieArray?.count ?? 0
    }
    //MARK: - ячейка для элемента
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCells.nowPlayingCell, for: indexPath) as? SerieCollectionViewCell
        else {
            return UICollectionViewCell() }
        
        cell.posterLabel.text = self.serieArray?[indexPath.row].name ?? self.serieArray?[indexPath.row].originalName
        cell.posterImage.layer.cornerRadius = cell.posterImage.frame.size.height * 0.08

        if let posterPath = self.serieArray?[indexPath.row].posterPath{
            let downloadPosterImage = URL(string: "\(SerieConstants.baseImageURL)\(posterPath)")
            cell.posterImage.kf.setImage(with: downloadPosterImage)
        }
        return cell
    }
}

// MARK: - Collection View Delegate
extension SerieTableViewCell: UICollectionViewDelegate {
    //MARK: - проверка получения данных выбран ли элемент
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let title = serieArray?[indexPath.row].name ?? serieArray?[indexPath.row].originalName ?? ""
        let posterURL = serieArray?[indexPath.row].posterPath ?? ""
        let overview = serieArray?[indexPath.row].overview ?? ""
        let releaseDate = serieArray?[indexPath.row].firstAirDate ?? ""
        let movieId = serieArray?[indexPath.row].id ?? 0
        let voteAverage = serieArray?[indexPath.row].voteAverage ?? 0
        let voteCount = serieArray?[indexPath.row].voteCount ?? 0
        
        guard let serieGenreArray = serieArray?[indexPath.row].genreIDS else { return }
        let serieGenreCount = serieGenreArray.count
        
        guard let genreDataCount = self.genreData?.count else { return }
        
        var genreResult : String = ""
        
        for serieGenreIndex in 0...serieGenreCount - 1 {
            for gDataIndex in 0...genreDataCount - 1 {
                if serieGenreArray[serieGenreIndex] == self.genreData?[gDataIndex].id{
                    guard let genreName = self.genreData?[gDataIndex].name else { return }
                    genreResult = genreResult + genreName + ", "
                }
            }
        }
        self.viewModel = DetailSerieModel(serieTitle: title, posterURL: posterURL, overview: overview, releaseDate: releaseDate, id: movieId, voteAverage: voteAverage, voteCount: voteCount, genre: genreResult)

        self.delegate?.updateViewController(self, model: self.viewModel!)
    }
}

