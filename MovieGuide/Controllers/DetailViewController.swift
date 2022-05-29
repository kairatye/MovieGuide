//
//  DetailViewController.swift
//  MovieGuide
//
//  Created by Kairat Yelubay on 27.05.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var searchResult: SearchResult!
    
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterImageView.contentMode = .scaleToFill
        posterImageView.layer.cornerRadius = posterImageView.frame.size.width / 8
        posterImageView.clipsToBounds = true

        if searchResult != nil {
            updateUI()
        }
    }
    
    deinit {
      print("deinit \(self)")
      downloadTask?.cancel()
    }
    
    func updateUI() {
        let basicURL = "https://image.tmdb.org/t/p/original"
        movieTitleLabel.text = searchResult.title
        overviewLabel.text = searchResult.movieOverview
        
        informationLabel.text = String(format: "%@, %@, %@", searchResult.releaseYear.prefix(4) as CVarArg, searchResult.originalTitle, searchResult.rating)
        if let imageURL = URL(string: basicURL + searchResult.poster) {
            downloadTask = posterImageView.loadImage(url: imageURL)
        }
    }

}
