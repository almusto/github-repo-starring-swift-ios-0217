//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositories(with completion: @escaping ([Any]) -> ()) {
      let string = "https://api.github.com/repositories?client_id=\(clientID)&client_secret=\(clientSecret)"
        let url = URL(string: string)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }) 
        task.resume()
    }

  class func checkIfRepositoryIsStarred(_ fullName: String, completion: @escaping (Bool) -> ()) {
    let urlString = "https://api.github.com/user/starred/\(fullName)?client_id=\(clientID)&client_secret=\(clientSecret)&access_token=\(token)"
    let url = URL(string: urlString)
    let session = URLSession.shared

    if let unwrappedURL = url {
      let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
        if let status = response as? HTTPURLResponse{
          if status.statusCode == 204 {
            completion(true)
          } else if status.statusCode == 404 {
            completion(false)
          } else {
            print(error ?? "error")
            completion(false)
          }

        }
      })

      task.resume()
    }


  }


  class func starRepository(named fullName: String, completion: @escaping ()->()) {
    let urlString = "https://api.github.com/user/starred/\(fullName)?client_id=\(clientID)&client_secret=\(clientSecret)&access_token=\(token)"
    let url = URL(string: urlString)
    let session = URLSession.shared

    if let unwrappedURL = url {
      var request = URLRequest(url: unwrappedURL)
      request.addValue("0", forHTTPHeaderField: "Content-Length")
      request.httpMethod = "PUT"


      let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
        if let status = response as? HTTPURLResponse {
          if status.statusCode == 204 {
            print(status.statusCode)
            completion()
          } else {
            print(error ?? "error")
          }
        }
      })
      task.resume()
      
    }
    
  }

  class func unstarRepository(named fullName: String, completion: @escaping ()->()) {
    let urlString = "https://api.github.com/user/starred/\(fullName)?client_id=\(clientID)&client_secret=\(clientSecret)&access_token=\(token)"
    let url = URL(string: urlString)
    let session = URLSession.shared

    if let unwrappedURL = url {
      var request = URLRequest(url: unwrappedURL)
      request.addValue("0", forHTTPHeaderField: "Content-Length")
      request.httpMethod = "DELETE"


      let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
        if let status = response as? HTTPURLResponse {
          if status.statusCode == 204 {
            print(status.statusCode)
            completion()
          } else {
            print(error ?? "error")
          }
        }
      })
      task.resume()
      
    }

  }
    
}

