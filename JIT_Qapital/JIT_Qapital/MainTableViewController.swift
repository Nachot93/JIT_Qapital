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
    var avatar : UIImage = UIImage(named: "user-icon-image-placeholder-300-grey.jpg")!
    private enum CodingKeys : String, CodingKey { case message, amount, userId, timestamp }
}

class MainTableViewController: UITableViewController  {
    
    var activities = [Activity]()
    
    // Connection with API
    fileprivate func getData(_ activitiesURL: URL, _ userURL: URL) {
        URLSession.shared.dataTask(with: activitiesURL) { (data, response, err) in
            guard let data = data else { return }
            do {
                // Activities
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let result = try decoder.decode(Root.self, from: data)
                self.activities = result.activities
            } catch {
                print("Error serializing json: ", error)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        // URLs
        let userJSONURLString = "https://qapital-ios-testtask.herokuapp.com/users"
        let activitiesJSONURLString = "https://qapital-ios-testtask.herokuapp.com/activities?from=2016-05-23T00:00:00+00:00&to=2019-05-23T00:00:00+00:00"
        guard let userURL = URL(string: userJSONURLString) else { return }
        guard let activitiesURL = URL(string: activitiesJSONURLString) else { return }
        
        getData(activitiesURL, userURL)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    // Get date of each activity
    fileprivate func getDate(_ activity: Activity, _ cell: MainTableViewCell) {
        let timeInterval = activity.timestamp.timeIntervalSinceNow
        let date = Date(timeIntervalSinceNow: timeInterval)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        dateFormatter.doesRelativeDateFormatting = true
        cell.dateLabel.text = dateFormatter.string(from: date)
    }
    
    fileprivate func getMessage(_ activity: Activity, _ cell: MainTableViewCell) {
        // Message
        let message = activity.message
        let formattedMessage = message.htmlAttributedString().with(font:UIFont(name: "BentonSans", size: 15)!)
        cell.descriptionLabel.attributedText = formattedMessage
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! MainTableViewCell
        let activity = activities[indexPath.row]
        
        // Amount
        cell.amountLabel.text = String(format: "$%.2f", activity.amount)
        
        getMessage(activity, cell)
        
        // Date
        getDate(activity, cell)
        
        // Avatar
        cell.imgView.image = activity.avatar
        
        return cell
    }
}

extension String {
    func htmlAttributedString() -> NSMutableAttributedString {
        
        guard let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
            else { return NSMutableAttributedString() }
        
        guard let formattedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else { return NSMutableAttributedString() }
        
        return formattedString
    }
    
}

extension NSMutableAttributedString {
    
    func with(font: UIFont) -> NSMutableAttributedString {
        self.enumerateAttribute(NSAttributedString.Key.font, in: NSMakeRange(0, self.length), options: .longestEffectiveRangeNotRequired, using: { (value, range, stop) in
            let originalFont = value as! UIFont
            if let newFont = applyTraitsFromFont(originalFont, to: font) {
                self.addAttribute(NSAttributedString.Key.font, value: newFont, range: range)
            }
        })
        return self
    }
    
    func applyTraitsFromFont(_ f1: UIFont, to f2: UIFont) -> UIFont? {
        let originalTrait = f1.fontDescriptor.symbolicTraits
        
        if originalTrait.contains(.traitBold) {
            var traits = f2.fontDescriptor.symbolicTraits
            traits.insert(.traitBold)
            if let fd = f2.fontDescriptor.withSymbolicTraits(traits) {
                return UIFont.init(descriptor: fd, size: 0)
            }
        }
        return f2
    }
}
