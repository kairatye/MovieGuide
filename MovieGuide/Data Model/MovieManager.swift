//
//  PopularMovie.swift
//  MovieGuide
//
//  Created by Kairat Yelubay on 29.05.2022.
//

import Foundation

protocol MovieManagerDelegate {
    func didUpdateMovieData(_ data: [SearchResult])
}

struct MovieManager {
    
    private let apiKey = "7bc008aaab4ab8d274e3de6b2af41bd5"
    private let language = "ru-Rus"
    
    var delegate: MovieManagerDelegate?
    
    func performRequest() {
        let popularMovieURL = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=\(language)"
        if let url = URL(string: popularMovieURL) {
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200, let data = data {
                    let result = parseJSON(data: data)
                    self.delegate?.didUpdateMovieData(result)
                }
            }
            task.resume()
        }
    }

    private func getPopularURL() -> URL {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=\(language)"
        let url = URL(string: urlString)
        return url!
    }
    
    private func parseJSON(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(ResultArray.self, from: data)
            return decodedData.results
        } catch {
            print("JSON error: \(error)")
            return []
        }
    }
}
