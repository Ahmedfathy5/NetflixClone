//
//  APICaller.swift
//  NetFlix
//
//  Created by Ahmed Fathi on 05/09/2023.
//

import Foundation

struct constants {
    static let API_KEY = "ae9b70195c0464b60861d48412ed25fc"
    static let BaseURL = "https://api.themoviedb.org"
    static let YOUTUPEAPI_KEY = "AIzaSyASDYS08vCUv2HrArpyPOQQYrvxzYwtEjk"
    static let YoutupeBaseUrl = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIError{
    case failledToGetData
}
class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping (Result<[Title],Error>) ->Void) {
        
        guard let url = URL(string: "\(constants.BaseURL)/3/trending/movie/day?api_key=\(constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            do {
                let results = try JSONDecoder().decode(TrndingTitleResponse.self, from: data)
                
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failledToGetData as! Error))
            }
            
        }
        
        task.resume()
    }
    
    func getTrendingTvs(completion: @escaping (Result<[Title],Error>) ->Void) {
        guard let url = URL(string: "\(constants.BaseURL)/3/trending/tv/day?api_key=\(constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url){ data, _, error in
            guard let data = data , error == nil else {return}
            do {
                let results = try JSONDecoder().decode(TrndingTitleResponse.self, from: data)
                
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failledToGetData as! Error))
            }
            
        }
        
        task.resume()
    }
    func getUpCommingMovie(completion: @escaping (Result<[Title],Error>) ->Void) {
        guard let url = URL(string: "\(constants.BaseURL)/3/movie/upcoming?api_key=\(constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            do{
                let results = try JSONDecoder().decode(TrndingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failledToGetData as! Error))
            }
        }
        task.resume()
    }
    
    func getPopular(completion: @escaping (Result<[Title],Error>) ->Void) {
        guard let url = URL(string: "\(constants.BaseURL)/3/movie/popular?api_key=\(constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            do{
                let results = try JSONDecoder().decode(TrndingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failledToGetData as! Error))
            }
        }
        task.resume()
    }
    func getTopRated(completion: @escaping (Result<[Title],Error>) ->Void) {
        guard let url = URL(string: "\(constants.BaseURL)/3/movie/top_rated?api_key=\(constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            do{
                let results = try JSONDecoder().decode(TrndingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failledToGetData as! Error))
            }
        }
        task.resume()
    }
    
  //curl --request GET \
  //  --url 'https://api.themoviedb.org/3/search/movie?query=Jack+Reacher&api_key=ae9b70195c0464b60861d48412ed25fc'
    func getDiscoverMovies(completion: @escaping (Result<[Title],Error>) ->Void) {
        guard let url = URL(string: "\(constants.BaseURL)/3/search/movie?query=Jack+Reacher&api_key=\(constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            do{
                let results = try JSONDecoder().decode(TrndingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failledToGetData as! Error))
            }
        }
        task.resume()
    }
    
    //'https://api.themoviedb.org/3/search/movie?query=Jack+Reacher&api_key=<<api_key>>'
    func search (with query : String , completion: @escaping (Result<[Title],Error>) ->Void){
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{return}
        
        guard let url = URL(string: "\(constants.BaseURL)/3/search/movie?query=\(query)&api_key=\(constants.API_KEY)") else {return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            do{
                let results = try JSONDecoder().decode(TrndingTitleResponse.self, from: data)
                completion(.success(results.results))
            }catch{
                completion(.failure(APIError.failledToGetData as! Error))
            }
        }
        task.resume()
    }
    func getMovie (with query :String, completion: @escaping (Result<VideoElement,Error>) ->Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{return}
        guard let url = URL(string: "\(constants.YoutupeBaseUrl)q=\(query)&key=\(constants.YOUTUPEAPI_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data , error == nil else {return}
            do{
                let results = try JSONDecoder().decode(YoutupeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
            }catch{
                completion(.failure(APIError.failledToGetData as! Error))
            }
        
        }
        task.resume()
    }
}
