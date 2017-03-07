//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
  var isStarred: Bool = false
    
    var repositories:[GithubRepository] = []
    
    func getRepositories(with completion: @escaping () -> ()) {
        GithubAPIClient.getRepositories { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
                
            }
            completion()
        }
    }

  func toggleStarStatus(for object: GithubRepository, completion: @escaping (Bool)->()) {
    GithubAPIClient.checkIfRepositoryIsStarred(object.fullName) { (isStarred) in
      if isStarred == false {
        GithubAPIClient.starRepository(named: object.fullName) {
          completion(true)
        }

      } else {
        GithubAPIClient.unstarRepository(named: object.fullName) {
          completion(false)
        }

      }

    }
    
  }

}
