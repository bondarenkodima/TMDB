//
//  SearchTableViewCell.swift
//  TMDB app
//
//  Created by MacBook Pro on 05.01.2023.

//MARK: - Frameworks
import UIKit
import Kingfisher

//MARK: - Search Table View Cell
class SearchTableViewCell: UITableViewCell {
    
    //MARK: - аутлеты
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var serieTitle: UILabel!
    
    //MARK: - жизненный цикл
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImage.layer.cornerRadius = posterImage.frame.size.height * 0.08
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
