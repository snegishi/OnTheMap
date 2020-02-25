//
//  InputLocationViewController.swift
//  OnTheMap
//
//  Created by Shin Negishi on 2/22/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class InputLocationViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - IBOutlets
    @IBOutlet weak var locationTextField: UITextField!
    
    // MARK: - Life Cycle
    
    
    @IBAction func findLocation() {
        self.performSegue(withIdentifier: "submitLocationIdentifier", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let submitVC = segue.destination as! SubmitLocationViewController
        submitVC.location = locationTextField.text!
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

