//
//  SerieViewController.swift
//  TMDB app
//
//  Created by MacBook Pro on 27.12.2022.

//MARK: - Frameworks
import UIKit

// MARK: - Table View секции сериала
enum SectionsSerie : Int {
    case airingToday = 0
    case onTheAir = 1
    case popular = 2
    case topRated = 3
}

// MARK: - View Controller сериалы
class SerieViewController: UIViewController {
    
    //MARK: - аутлет Table View сериалы
    @IBOutlet weak var serieTableView: UITableView!
    
    //MARK: - объекты
    let sectionTitles = ["AIRNING TODAY", "ON THE AIR", "POPULAR", "TOP RATED"]
    var tableViewCell = SerieTableViewCell()
    var serieManager = SerieManager()
    var viewModel : DetailSerieModel?
    private var genreData : [Genre]? = [Genre]()
    
    //MARK: - жизненый цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        serieTableView.dataSource = self
        serieTableView.delegate = self
        fetchGenreData()
    }
    
    //MARK: - нажатие поиска
    @IBAction func searchButtonDidPress(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Segues.toSearchVC, sender: nil)
    }
    
    //MARK: - получение жанра
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

// MARK: - Table View Data Source
extension SerieViewController: UITableViewDataSource {
   
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
        guard let cell = serieTableView.dequeueReusableCell(withIdentifier: TableViewCells.serieTableViewCell, for: indexPath) as? SerieTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        
        switch indexPath.section {
        case SectionsSerie.airingToday.rawValue:
            self.serieManager.performRequest(url: URLAddressSerie().urlAiringToday) { results in
                switch results{
                case.success(let serie):
                    cell.configure(with: serie.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case SectionsSerie.onTheAir.rawValue:
            self.serieManager.performRequest(url: URLAddressSerie().urlOnTheAir) { results in
                switch results{
                case.success(let serie):
                    cell.configure(with: serie.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case SectionsSerie.popular.rawValue:
            self.serieManager.performRequest(url: URLAddressSerie().urlPopular) { results in
                switch results{
                case.success(let serie):
                    cell.configure(with: serie.results)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case SectionsSerie.topRated.rawValue:
            self.serieManager.performRequest(url: URLAddressSerie().urlTopRated) { results in
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
extension SerieViewController: UITableViewDelegate{
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

// MARK: - SerieTableViewCellDelegate
extension SerieViewController: SerieTableViewCellDelegate {
    //MARK: - переход во вьюшку с деталями
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toDetailVC {
            let destinationVC = segue.destination as! SerieDetailViewController
            destinationVC.viewModel = self.viewModel
            destinationVC.genreData = self.genreData
        }
    }
    
    //MARK: - обновление ViewController
    func updateViewController(_ cell: SerieTableViewCell, model: DetailSerieModel) {
        DispatchQueue.main.async {
            self.viewModel = model
            self.performSegue(withIdentifier: Segues.toDetailVC, sender: nil)
        }
    }
}
