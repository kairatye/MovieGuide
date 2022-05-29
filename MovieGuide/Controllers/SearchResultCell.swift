//
//  MovieName.swift
//  MovieGuide
//
//  Created by Kairat Yelubay on 25.05.2022.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieRating: UILabel!
    
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterImageView.contentMode = .scaleToFill
        posterImageView.layer.cornerRadius = posterImageView.frame.size.width / 10
        posterImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    //MARK: - Helper Methods
    
    func configure(for result: SearchResult) {
        let basicURL = "https://image.tmdb.org/t/p/original"
        movieTitle.text = result.title
        originalTitle.text = String(format: "%@, %@", result.originalTitle, result.releaseYear.prefix(4) as CVarArg)
        
        posterImageView.image = UIImage(systemName: "photo")
        if let imageURL = URL(string: basicURL + result.poster) {
            downloadTask = posterImageView.loadImage(url: imageURL)
        }
        
        if result.rating == "0.0" {
            movieRating.text = ""
        } else {
            movieRating.text = result.rating
        }
    }
}
