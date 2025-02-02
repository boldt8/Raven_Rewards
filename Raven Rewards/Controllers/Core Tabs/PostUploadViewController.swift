//
//  CameraViewController.swift
//  Instagram
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import AVFoundation
import UIKit
import SwiftUI

/// Controller to handle taking pictures or choosing from Library
final class PostUploadViewController: UIViewController {

    private var isUploadingShop = false
    private var output = AVCapturePhotoOutput()
    private var captureSession: AVCaptureSession?
    private let previewLayer = AVCaptureVideoPreviewLayer()

    private let cameraView = UIView()

    private let shutterButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.backgroundColor = nil
        return button
    }()

    private let photoPickerButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40)),
                        for: .normal)
        
        return button
    }()
    
    let shopButton = UIButton(frame: CGRect(x: 0, y: 0, width: 220, height: 50))
    
    let uploadShopButton = UIButton(frame: CGRect(x: 0, y: 0, width: 220, height: 50))
    
    let bubble: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Visit the student store to redeem rewards!"))
        return image
    }()
    
    @objc func didTapShopButton() {
        Task{
            let data = try await DatabaseManager.shared.shopPosts()

            let vc = UIHostingController(rootView: Raven_Shop(data: RavenShopData(posts: data)))
            present(vc, animated: true)
        }
    }
    
    @objc func didTapPickShopPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        isUploadingShop = true
        present(picker, animated: true)
    }
    private func fetchUser(username: String, handler: @escaping ((Bool) -> Void)) {
        DatabaseManager.shared.findUser(username: username) { [weak self] user in
            if let user = user {
                DispatchQueue.main.async {
                    handler(user.isAdmin)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        title = "Raven Shop"
        view.addSubview(cameraView)
        view.addSubview(shutterButton)
        view.addSubview(photoPickerButton)
        view.addSubview(shopButton)
        view.addSubview(uploadShopButton)
        view.addSubview(bubble)
        self.uploadShopButton.isHidden = true
        self.cameraView.isHidden = true
        self.shutterButton.isHidden = true
        self.photoPickerButton.isHidden = true
        setUpNavBar()
        checkCameraPermission()
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        photoPickerButton.addTarget(self, action: #selector(didTapPickPhoto), for: .touchUpInside)
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        fetchUser(username: username) { (result) in
            if(result){
                self.uploadShopButton.isHidden = false
                self.cameraView.isHidden = false
                self.shutterButton.isHidden = false
                self.photoPickerButton.isHidden = false
                self.bubble.isHidden = true
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
        if let session = captureSession, !session.isRunning {
            session.startRunning()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bubSize = CGFloat(300)
        
        bubble.frame = CGRect(x: view.width/2,
                              y: view.safeAreaInsets.top + view.height*5/32,
                              width: bubSize,
                               height: bubSize)
        bubble.center = CGPoint(x: view.width/2,  y: view.safeAreaInsets.top + view.height*4/16)
        shopButton.center = CGPoint(x: view.width/2, y: view.height/2)
        shopButton.setTitle("View Raven Shop", for: .normal)
        shopButton.backgroundColor = .systemPink
        shopButton.addTarget(self, action: #selector(didTapShopButton), for: .touchUpInside)
        uploadShopButton.center = CGPoint(x: view.width/2, y: view.height*15/16)
        uploadShopButton.setTitle("Upload to Raven Shop", for: .normal)
        uploadShopButton.backgroundColor = .systemPink
        uploadShopButton.addTarget(self, action: #selector(didTapPickShopPhoto), for: .touchUpInside)
        
        cameraView.frame = view.bounds
        previewLayer.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.width
        )

        let buttonSize: CGFloat = view.width/5
        shutterButton.frame = CGRect(
            x: (view.width-buttonSize)/2,
            y: view.safeAreaInsets.top + view.width + 100,
            width: buttonSize,
            height: buttonSize
        )
        shutterButton.layer.cornerRadius = buttonSize/2

        photoPickerButton.frame = CGRect(x: (shutterButton.left - (buttonSize/1.5))/2,
                                         y: shutterButton.top + ((buttonSize/1.5)/2),
                                         width: buttonSize/1.5,
                                         height: buttonSize/1.5)
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }
        fetchUser(username: username) { (result) in
            if(result){
                self.shopButton.center = CGPoint(x: self.view.width/2, y: self.view.height*14/16)
            }
        }
    }

    @objc func didTapPickPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(),
                            delegate: self)
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .notDetermined:
            // request
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .authorized:
            setUpCamera()
        case .restricted, .denied:
            break
        @unknown default:
            break
        }
    }

    private func setUpCamera() {
        let captureSession = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            }
            catch {
                print(error)
            }

            if captureSession.canAddOutput(output) {
                captureSession.addOutput(output)
            }

            // Layer
            previewLayer.session = captureSession
            previewLayer.videoGravity = .resizeAspectFill
            cameraView.layer.addSublayer(previewLayer)

            captureSession.startRunning()
            
        }
    }

    @objc func didTapClose() {
        tabBarController?.selectedIndex = 0
        tabBarController?.tabBar.isHidden = false
    }

    private func setUpNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
}

extension PostUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        if(!isUploadingShop){
            showEditPhoto(image: image)
        }
        if(isUploadingShop){
            shopEditPhoto(image: image)
        }
        isUploadingShop = false
    }
}

extension PostUploadViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            return
        }
        captureSession?.stopRunning()
        showEditPhoto(image: image)
    }
    private func shopEditPhoto(image: UIImage) {
        guard let resizedImage = image.sd_resizedImage(
            with: CGSize(width: 640, height: 640),
            scaleMode: .aspectFill
        ) else {
            return
        }

        let vc = ShopEditViewController(image: resizedImage)
        if #available(iOS 14.0, *) {
            vc.navigationItem.backButtonDisplayMode = .minimal
        }
        navigationController?.pushViewController(vc, animated: false)

    }

    private func showEditPhoto(image: UIImage) {
        guard let resizedImage = image.sd_resizedImage(
            with: CGSize(width: 640, height: 640),
            scaleMode: .aspectFill
        ) else {
            return
        }

        let vc = PostEditViewController(image: resizedImage)
        if #available(iOS 14.0, *) {
            vc.navigationItem.backButtonDisplayMode = .minimal
        }
        navigationController?.pushViewController(vc, animated: false)

    }
}
