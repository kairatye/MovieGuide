//
//  MainViewController.swift
//  MovieGuide
//
//  Created by Kairat Yelubay on 29.05.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var popularMovies = [SearchResult]()
    
    var movieManager = MovieManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieManager.delegate = self
        
        DispatchQueue.global().async {
            self.movieManager.performRequest()
        }
        
        let cellNib = UINib(nibName: SearchViewController.TableView.CellIdentifiers.searchResultCell, bundle: nil)
        
        tableView.register(cellNib, forCellReuseIdentifier: SearchViewController.TableView.CellIdentifiers.searchResultCell)
    }
}

//MARK: - Table View Delegate

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        popularMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchViewController.TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
        let popularMovie = popularMovies[indexPath.row]
        cell.configure(for: popularMovie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "ShowPopularDetail", sender: indexPath)
    
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPopularDetail" {
            let detailVC = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            let popularMovie = popularMovies[indexPath.row]
            detailVC.searchResult = popularMovie
        }
    }
}

extension MainViewController: MovieManagerDelegate {
    func didUpdateMovieData(_ data: [SearchResult]) {
        DispatchQueue.main.async {
            self.popularMovies = data
            self.tableView.reloadData()
        }
    }
}
