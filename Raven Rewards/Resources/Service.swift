//
//  Service.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 2/19/25.
//

import UIKit

class Service {
    static func createAlertController(title: String, message: String, vc: UIViewController) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "dismiss", style: .default){
            (action) in alert.dismiss(animated: true, completion: {
                vc.dismiss(animated: true, completion: nil)
            })
        }
        
        alert.addAction(okAction)
        
        return alert
    }
}
