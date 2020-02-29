//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by Shin Negishi on 2/22/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - IBOutlets
    
//    @IBOutlet weak var tableView: UITableView!
        
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Get Student List
    func getStudentList() {
//        OnTheMapClient.getStudentLocations(uniqueKey: "", completion: self.handleStudentsResponse(studentLocations:error:))
    }
    
    func handleStudentsResponse(studentLocations: [StudentInformation], error: Error?) {
        if !studentLocations.isEmpty {
            
        }
    }
}

extension StudentListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationModel.locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")!
        let studentLocation = LocationModel.locations[indexPath.row]//locations[indexPath.row]

        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"

        return cell
    }

}
