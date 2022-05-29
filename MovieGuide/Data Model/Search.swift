//
//  Search.swift
//  MovieGuide
//
//  Created by Kairat Yelubay on 26.05.2022.
//

import Foundation

typealias SearchComplete = (Bool) -> Void

class Search {
    enum State {
        case notSearchedYet
        case loading
        case noResults
        case results([SearchResult])
    }
    
    private(set) var state: State = .notSearchedYet
    
    private var dataTask: URLSessionDataTask?
    
    private let apiKey = "7bc008aaab4ab8d274e3de6b2af41bd5"
    private let language = "ru-Rus"

    func performSearch(for text: String, completion: @escaping SearchComplete) {
        if !text.isEmpty {
            dataTask?.cancel()
            
            state = .loading
            
            let url = searchURL(searchText: text)
            
            let session = URLSession.shared
            dataTask = session.dataTask(with: url) { data, response, error in
                var newState = State.notSearchedYet
                var success = false
                
                if let error = error as NSError?, error.code == -999 {
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200, let data = data {
                    let searchResults = self.parseJSON(data: data)
                    if searchResults.isEmpty {
                        newState = .noResults
                    } else {
                        newState = .results(searchResults)
                    }
                    success = true
                }
                
                DispatchQueue.main.async {
                    self.state = newState
                    completion(success)
                }
            }
            dataTask?.resume()
        }
    }
    
    private func searchURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=\(language)&query=\(encodedText)"
        let url = URL(string: urlString)
        return url!
    }

    private func parseJSON(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(ResultArray.self, from: data)
            return result.results
        } catch {
            print("JSON error: \(error)")
            return []
        }
    }
}
