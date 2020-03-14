//
//  UIViewController.swift
//  OnTheMap
//
//  Created by Shin Negishi on 3/14/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // MARK: - Error Message
    
    func showPostFailure(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
