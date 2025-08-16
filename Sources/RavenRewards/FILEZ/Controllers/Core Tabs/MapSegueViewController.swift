//
//  MapSegue.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 2/26/25.
//
#if os(iOS)
#if os(iOS)
import UIKit
#endif
import SwiftUI
#endif

class MapSegueViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Event Map"
    }
    
    @IBSegueAction func mapSeque(_ coder: NSCoder) -> UIViewController? {
        
        
        return UIHostingController(coder: coder, rootView: SwiftfulMapAppApp())
    }
    
}
