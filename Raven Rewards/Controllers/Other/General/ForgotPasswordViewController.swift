//
//  RegistrationViewController.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 8/3/24.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    let sendEmailButton = UIButton(frame: CGRect(x: 0, y: 0, width: 220, height: 50))
    
    private let usernameEmailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email..."
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    
    private let loadingButton = UIButton(frame: CGRect(x: 0, y: 0, width: 220, height: 50))
    
    @objc func didTapClose() {
        self.dismiss(animated: true, completion: nil)
    }

    private func setUpNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        view.addSubview(usernameEmailField)
        view.addSubview(sendEmailButton)
        view.addSubview(loadingButton)
        loadingButton.isHidden = true
        view.backgroundColor = .white
    }
    
    @objc private func didTapSendEmailButton(){
        loadingButton.isHidden = false
        sendEmailButton.isHidden = true
        guard let email = usernameEmailField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            sendEmailButton.isHidden = false
            loadingButton.isHidden = true
            return
        }
        let auth = AuthManager.shared.auth
        
        auth.sendPasswordReset(withEmail: email){ (error) in
            // doesn't account for all errors?
            guard let vc = self.presentingViewController else { return }
            if error != nil {
                
                let alert = Service.createAlertController(title: "Error", message: error!.localizedDescription, vc: vc)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = Service.createAlertController(title: "Success", message:"A password resent email has been sent!", vc: vc)
                self.present(alert, animated: true, completion: nil)
            }
            
            self.loadingButton.isHidden = true
            self.sendEmailButton.isHidden = false
            
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        sendEmailButton.center = CGPoint(x: view.width/2, y: view.height/2)
        sendEmailButton.setTitle("Send Email", for: .normal)
        sendEmailButton.backgroundColor = .systemPink
        sendEmailButton.addTarget(self, action: #selector(didTapSendEmailButton), for: .touchUpInside)
        
        loadingButton.center = CGPoint(x: view.width/2, y: view.height/2)
        loadingButton.setTitle("Loading...", for: .normal)
        loadingButton.backgroundColor = .systemOrange
        
        
        usernameEmailField.frame = CGRect(
            x: 25,
            y: 100,
            width: view.width - 50,
            height: 52.0
        )
    }
}
