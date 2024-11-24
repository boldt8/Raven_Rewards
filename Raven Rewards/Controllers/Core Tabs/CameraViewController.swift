//
//  CameraViewController.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 8/3/24.
//

import AVFoundation
import UIKit
import CoreImage.CIFilterBuiltins



class CameraViewController: UIViewController {
    private let QR: UIImageView = {
        let qrCode: UIImage = {
            let contex = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            var url: String
            
            let view = imageGenerate("")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view.
        
        view.addSubview(QR)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        QR.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/2)
        QR.center = view.center
    }
    
    private func didTakePicture() {
        
    }
    

}
