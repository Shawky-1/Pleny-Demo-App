//
//  NetworkManger.swift
//  Pleny_Demo_App
//
//  Created by Ahmed Shawky on 07/03/2023.
//

import Foundation


class NetworkManger {
    static func loginUser(username: String, password: String, completion: @escaping (Result<User, Error>) -> ()) {
        let credentials = ["username": username, "password": password]
        let jsonData = try! JSONSerialization.data(withJSONObject: credentials, options: [])
        let url = URL(string: "https://dummyjson.com/auth/login")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "loginUser", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"])
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorMessage = APIError(statusCode: httpResponse.statusCode, data: data)
                completion(.failure(errorMessage))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "loginUser", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty Response Data"])
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }

    
    static func fetchPosts(page: Int = 1,completion: @escaping (Result<[Post], Error>) -> ()) {
        let skip = page * 10
        let url = URL(string: "https://dummyjson.com/posts?limit=10&skip=\(skip)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "fetchPosts", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"])
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "fetchPosts", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Response Error"])
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "fetchPosts", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty Response Data"])
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let PostsResponse = try decoder.decode(PostsResponse.self, from: data)
                completion(.success(PostsResponse.posts))
            } catch let error {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
        }.resume()
    }
    
    static func fetchUser(userID: Int, completion: @escaping (Result<PostUser, Error>) -> ()) {
        let urlString = "https://dummyjson.com/users/\(userID)"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "fetchUser", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "fetchUser", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP Response"])
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let error = NSError(domain: "fetchUser", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "HTTP Response Error"])
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "fetchUser", code: -1, userInfo: [NSLocalizedDescriptionKey: "Empty Response Data"])
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(PostUser.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }

    
    

}
