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




class CameraViewController: UIViewController, UITextViewDelegate {
    private let ravenPoints: UITextView = {
        let body = UITextView()
        body.text = "Current Raven Points: "
        body.font = UIFont(name: "GillSans-Bold", size: CGFloat(30))
        return body
    }()
    
    
    
    let helpButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
    
    private let QR: UIImageView = {
        let qrCode: UIImage = {
            let contex = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            var url: String
            let view = imageGenerate(AuthManager.shared.currUserID)
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
    
    let logo: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Logo 2"))
        return image
    }()
    
    private func fetchUser() {
        print("fetshing for camerview controller")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        view.addSubview(ravenPoints)
        view.addSubview(QR)
        // Check to see if admin user
        view.addSubview(scanButton)
        view.addSubview(helpButton)
//        view.addSubview(logo)
        self.scanButton.isHidden = true
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        DatabaseManager.shared.findUser(username: username) { [weak self] user in
            if let user = user {
                DispatchQueue.main.async {
                    self?.ravenPoints.text = "Current Raven Points: \(user.points)"
                    if(user.isAdmin){
                        self?.scanButton.isHidden = false
                    }
                    
                }
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ravenPoints.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/2)
        ravenPoints.center = CGPoint(x: view.width/2, y: view.height*1/4)
        QR.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/2)
        QR.center = view.center
        scanButton.center = CGPoint(x: view.width/2, y: view.height*3/4)
        scanButton.setTitle("Scan QR code", for: .normal)
        scanButton.backgroundColor = .systemPink
        scanButton.addTarget(self, action: #selector(didTapScanButton), for: .touchUpInside)
        helpButton.center = CGPoint(x: view.width*13/16, y: view.height*3/32)
        helpButton.setTitle("Help", for: .normal)
        helpButton.backgroundColor = .systemOrange
        helpButton.addTarget(self, action: #selector(didTapHelpButton), for: .touchUpInside)
        let logoSize = CGFloat(100)
        logo.frame = CGRect(x: view.width/16,
                                    y: view.safeAreaInsets.top + view.height*3/16,
                                     width: logoSize,
                                     height: logoSize)
    }
    
    @objc func didTapHelpButton() {
        let vc = InfoViewController()
        vc.title = "Info"
        
        present(UINavigationController(rootViewController: vc), animated:true)
    }
    
    @objc func didTapScanButton() {
        let vc = UIHostingController(rootView: QRScanner())
        present(vc, animated: true)
    }
}
