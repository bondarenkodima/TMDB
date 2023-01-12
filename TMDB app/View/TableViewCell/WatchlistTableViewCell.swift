//
//  WatchlistTableViewCell.swift
//  TMDB app
//
//  Created by MacBook Pro on 08.01.2023.

//MARK: - Frameworks
import UIKit

//MARK: - Watchlist Table View Cell
class WatchlistTableViewCell: UITableViewCell {
    
    //MARK: - аутлеты
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieScore: UILabel!
    
    
    //MARK: - жизненный цикл
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.layer.cornerRadius = movieImage.frame.size.height * 0.08
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
