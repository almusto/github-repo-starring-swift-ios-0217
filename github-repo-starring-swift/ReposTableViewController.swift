//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositories {
            OperationQueue.main.addOperation({ 
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)

        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName

        return cell
    }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let repository = store.repositories[indexPath.row]

    store.toggleStarStatus(for: repository) { (isStarred) in

      if isStarred == false {
        let alertController = UIAlertController(title: "You just unstarred \(repository.fullName)", message: "", preferredStyle: .alert)
        let alert = UIAlertAction(title: "ok", style: .default, handler: {action in alertController.dismiss(animated: true, completion: nil)})
        alertController.addAction(alert)
        self.present(alertController, animated: true, completion: nil)

      } else {
        let alertController = UIAlertController(title: "You just starred \(repository.fullName)", message: "", preferredStyle: .alert)
        let alert = UIAlertAction(title: "ok", style: .default, handler: {action in alertController.dismiss(animated: true, completion: nil)})
        alertController.addAction(alert)
        self.present(alertController, animated: true, completion: nil)
        
      }
    }

  }

}
