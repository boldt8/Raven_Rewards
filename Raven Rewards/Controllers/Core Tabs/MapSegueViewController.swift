//
//  MapSegue.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 2/26/25.
//

import UIKit
import SwiftUI

class MapSegueViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBSegueAction func mapSeque(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: SwiftfulMapAppApp())
    }
    
}
