//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Shin Negishi on 2/22/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationModel.locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")!
        let studentLocation = LocationModel.locations[indexPath.row]

        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel?.text = studentLocation.mediaURL
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let toOpen = LocationModel.locations[indexPath.row].mediaURL
        app.openURL(URL(string: toOpen)!)
    }
}
