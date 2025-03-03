//
//  CameraViewController.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 8/3/24.
//

import AVFoundation
import UIKit
import SafariServices
import CoreImage.CIFilterBuiltins
import SwiftUI




class CameraViewController: UIViewController, UITextViewDelegate {
    private let ravenPoints: UITextView = {
        let body = UITextView()
        body.text = "Current Raven Points: "
        body.isEditable = false
        body.isSelectable = false
        body.isScrollEnabled = false
        body.font = UIFont(name: "GillSans-Bold", size: CGFloat(30))
        return body
    }()
    
    
    
    let helpButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
    
    private func makeQR(username: String) -> UIImageView {
        let qrCode: UIImage = {
            let contex = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            let view = imageGenerate(username)
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
    }
    
    private var QR: UIImageView = {
        return UIImageView()
    }()
    
    let scanButton = UIButton(frame: CGRect(x: 0, y: 0, width: 220, height: 50))
    
    let logo: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Logo 2"))
        return image
    }()
    
    let bubble: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Scan your QR code for Raven Points!"))
        return image
    }()
    
    private func openURL(urlString: String) {
        
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    
    private func fetchUser(username: String) {
        guard let userVersion = Double(Bundle.main.currentUserVersion!) else {
                return
        }
            DatabaseManager.shared.findUser(username: username) { [weak self] user in
                if let user = user {
                    DatabaseManager.shared.incrVersion(username: username, version: userVersion)
                    DatabaseManager.shared.getCurrentVersion { [weak self] currVer in
                        guard let currentVersion = currVer else {
                            print("\n\nFetching Error")
                            return
                        }
                        if(userVersion != currentVersion){
                            let alert = UIAlertController(title: "Version Outdated",
                                                          message: "You are on an old version of the app, please update",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Update",
                                                          style: .cancel,
                                                          handler: {action in
                                self?.openURL(urlString: "https://apps.apple.com/us/app/raven-rewards/id6740197422")
                            }))
                            alert.addAction(UIAlertAction(title: "Nope",
                                                          style: .default,
                                                          handler: {action in
                                self?.dismiss(animated: true, completion: nil)
                            }))
                            
                            self?.present(alert, animated: true)
                        }
                    }
                    DispatchQueue.main.async {
                        self?.ravenPoints.text = "Current Raven Points: \(user.points)"
                        if(user.isAdmin){
                            self?.scanButton.isHidden = false
                        }
                        self?.QR = self?.makeQR(username: username) ?? UIImageView()
                        self?.view.addSubview(self?.QR ?? UIImageView())
                    }
                    
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LocationsDataService.fetchLocs()
        self.navigationController?.isNavigationBarHidden = true
        view.addSubview(ravenPoints)
        // Check to see if admin user
        view.addSubview(scanButton)
        view.addSubview(helpButton)
        view.addSubview(logo)
        view.addSubview(bubble)
        self.scanButton.isHidden = true
        
        AuthManager.shared.getCurrUserID(completion: { [weak self] success in
            self?.fetchUser(username: success)
            
        })
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Used for first time download
        if (!UserDefaults.standard.bool(forKey: "hasRunBefore")) {
            print("The app is launching for the first time. Setting UserDefaults...")
            
            AuthManager.shared.signOut(completion: { success in
                DispatchQueue.main.async {
                    if success {
                        // present log in
                        let loginVC = LoginViewController(firstTimeLogin: true)
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                       
                    }
                    else {
                        // error occurred
                        fatalError("Could not log out user")
                    }
                }
            })
            
            // Update the flag indicator
            UserDefaults.standard.set(true, forKey: "hasRunBefore")
            UserDefaults.standard.synchronize() // This forces the app to update userDefaults
            
        }
        // used for when you manually sign out or if you try to evade login
        if AuthManager.shared.isSignedIn == false {
            // Show log in
            let loginVC = LoginViewController(firstTimeLogin: true)
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true) {
                self.navigationController?.popToRootViewController(animated: false)
                self.tabBarController?.selectedIndex = 0
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ravenPoints.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/2)
        ravenPoints.center = CGPoint(x: view.width/2, y: view.height*1/8)
        QR.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/2)
        QR.center = CGPoint(x: view.width/2, y: view.height*9/16)
        scanButton.center = CGPoint(x: view.width/2, y: view.height*3/4)
        scanButton.setTitle("Scan QR code", for: .normal)
        scanButton.backgroundColor = .systemPink
        scanButton.addTarget(self, action: #selector(didTapScanButton), for: .touchUpInside)
        helpButton.center = CGPoint(x: view.width*13/16, y: view.height*3/32)
        helpButton.setTitle("Help", for: .normal)
        helpButton.backgroundColor = .systemOrange
        helpButton.addTarget(self, action: #selector(didTapHelpButton), for: .touchUpInside)
        let logoSize = CGFloat(100)
        logo.frame = CGRect(x: view.width*2/16,
                                    y: view.safeAreaInsets.top + view.height*7/32,
                                     width: logoSize,
                                     height: logoSize)
        bubble.frame = CGRect(x: view.width*2/16,
                                    y: view.safeAreaInsets.top + view.height*1/16,
                                     width: logoSize * 3,
                                     height: logoSize * 3)
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

private extension Bundle {
    var currentUserVersion: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
}

