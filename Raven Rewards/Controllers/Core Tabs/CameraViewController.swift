//
//  CameraViewController.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 8/3/24.
//

import AVFoundation
import UIKit
import CoreImage.CIFilterBuiltins
import SwiftUI




class CameraViewController: UIViewController {
    private let QR: UIImageView = {
        let qrCode: UIImage = {
            let contex = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            var url: String
            
            let view = imageGenerate("\(AuthManager.getUserName())")
            func imageGenerate(_ url: String) -> UIImage {
                let data = Data(url.utf8)
                filter.setValue(data, forKey: "inputMessage")
                if let qrcode = filter.outputImage {
                    if let qrcodeImage = contex.createCGImage(qrcode, from: qrcode.extent) {
                        return UIImage(cgImage: qrcodeImage)
                    }
                }
                return UIImage(systemName: "xmark") ?? UIImage()
            }
            
            return view
        }()
        return UIImageView(image: qrCode)
    }()
    
    let scanButton = UIButton(frame: CGRect(x: 0, y: 0, width: 220, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserName()
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        
        view.addSubview(QR)
        // Check to see if admin user
        if (true){
            view.addSubview(scanButton)
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        QR.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/2)
        QR.center = view.center
        scanButton.center = CGPoint(x: view.width/2, y: view.height*3/4)
        scanButton.setTitle("Scan QR code", for: .normal)
        scanButton.backgroundColor = .systemPink
        scanButton.addTarget(self, action: #selector(didTapScanButton), for: .touchUpInside)
        
    }
    
    private func fetchUserName() {
        let user = User(username: "Joe",
                        bio: "",
                        name: (first: "", last: ""),
                        profilePhoto: URL(string: "https://www.google.com")!,
                        birthDate: Date(),
                        gender: .male,
                        counts: UserCount(followers: 1, following: 1, posts: 1),
                        joinDate: Date())
    }
    
    @objc func didTapScanButton() {
        let vc = UIHostingController(rootView: QRScanner())
        present(vc, animated: true)
    }
}
