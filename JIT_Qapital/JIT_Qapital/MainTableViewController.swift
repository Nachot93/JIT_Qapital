//
//  MainTableViewController.swift
//  JIT_Qapital
//
//  Created by Juan Ignacio Tarallo on 04/06/2019.
//  Copyright © 2019 Juan Ignacio Tarallo. All rights reserved.
//

import UIKit

struct Root: Decodable {
    var oldest: Date
    var activities: [Activity]
}

struct Activity: Decodable {
    var message: String
    var amount: Float
    var userId: Int
    var timestamp: Date
}

struct Users: Decodable {
    var avatarUrl: String
    var displayName: String
    var userId: Int
}

class MainTableViewController: UITableViewController {
    
//    var activityList: Activities!
//    var activity: [Activity] = []
    var activities = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
//        tableView.prefetchDataSource = self
        
//        let userJSONURLString = "https://qapital-ios-testtask.herokuapp.com/users"
        let activitiesJSONURLString = "https://qapital-ios-testtask.herokuapp.com/activities?from=2016-05-23T00:00:00+00:00&to=2019-05-23T00:00:00+00:00"
//        guard let userURL = URL(string: userJSONURLString) else { return }
        guard let activitiesURL = URL(string: activitiesJSONURLString) else { return }
        
        URLSession.shared.dataTask(with: activitiesURL) { (data, response, err) in
            // perhaps check err
            // also perhaps check response status 200 OK
            
            guard let data = data else { return }
            
            do {
                // Activities
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let result = try decoder.decode(Root.self, from: data)
                self.activities = result.activities
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error serializing json: ", error)
            }
            
        }.resume()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! MainTableViewCell
        let activity = activities[indexPath.row]
        // assign the activity data to the UI for example
        // cell.someLabel = activity.amount
        
        cell.descriptionLabel.text = activity.message
//        cell.amountLabel.text = "$\(String(activity.amount))"
        cell.amountLabel.text = String(format: "$%.2f", activity.amount)
        return cell
    }
    
    // Prefetching (hace que cargue las cells a medida que vas scrolleando)
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        if indexPaths.contains(where: isLoadingCell) {
//            viewModel.fetchModerators()
//        }
//    }
}

