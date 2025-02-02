//
//  LoginViewController.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 8/3/24.
//

import SafariServices
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
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
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "Password..."
        field.returnKeyType = .continue
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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let helpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Help", for: .normal)
        button.setTitleColor(.secondaryLabel,
                             for: .normal)
        return button
    }()
    
    private let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(.secondaryLabel,
                             for: .normal)
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("New User? Create and Account", for: .normal)
        return button
    }()
    
    private let headerView: UIView = {
        let header = UIView()
        header.clipsToBounds = true
        let backgroundImageView = UIImageView(image: UIImage(named: "gradient"))
        header.addSubview(backgroundImageView)
        return header
    }()
    
    private func getInfo() {
        let vc = InfoViewController()
        vc.title = "Info"
        
        self.present(UINavigationController(rootViewController: vc), animated:true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loginButton.addTarget(self,
                              action: #selector(didTapLoginButton),
                              for: .touchUpInside)
        createAccountButton.addTarget(self,
                                      action: #selector(didTapCreateAccountButton),
                                      for: .touchUpInside)
        helpButton.addTarget(self,
                              action: #selector(didTapHelpButton),
                              for: .touchUpInside)
        privacyButton.addTarget(self,
                                action: #selector(didTapPrivacyButton),
                                for: .touchUpInside)
        
        usernameEmailField.delegate = self
        passwordField.delegate = self
        addSubviews()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getInfo()
        //assign frames
        
        headerView.frame = CGRect(
            x: 0,
            y: 0.0,
            width: view.width,
            height: view.height/3.0
        )
        
        usernameEmailField.frame = CGRect(
            x: 25,
            y: headerView.bottom + 40,
            width: view.width - 50,
            height: 52.0
        )
        
        passwordField.frame = CGRect(
            x: 25,
            y: usernameEmailField.bottom + 10,
            width: view.width - 50,
            height: 52.0
        )
        
        loginButton.frame = CGRect(
            x: 25,
            y: passwordField.bottom + 10,
            width: view.width - 50,
            height: 52.0
        )
        
        createAccountButton.frame = CGRect(
            x: 25,
            y: loginButton.bottom + 10,
            width: view.width - 50,
            height: 52.0
        )
        
        helpButton.frame = CGRect(
            x: 10,
            y: view.height-view.safeAreaInsets.bottom-100,
            width: view.width-20,
            height: 50
        )
        
        privacyButton.frame = CGRect(
            x: 10,
            y: view.height-view.safeAreaInsets.bottom-50,
            width: view.width-20,
            height: 50
        )
        
        configureHeaderView()
    }
    
    private func configureHeaderView() {
        guard headerView.subviews.count == 1 else {
            return
        }
        
        guard let backgroundView = headerView.subviews.first else {
            return
        }
        backgroundView.frame = headerView.bounds
        
        // Add instagram logo
        let imageView = UIImageView(image: UIImage(named: "text"))
        headerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0,
                                 y: view.safeAreaInsets.top,
                                 width: headerView.width,
                                 height: headerView.height - view.safeAreaInsets.top)
        let logoView = UIImageView(image: UIImage(named: "Logo"))
        headerView.addSubview(logoView)
        logoView.contentMode = .scaleAspectFill
        let logoSize = CGFloat(175)
        logoView.frame = CGRect(x: view.width/2 - logoSize/2,
                                y: view.safeAreaInsets.top + view.height*2/32,
                                 width: logoSize,
                                 height: logoSize)
    }
    
    private func addSubviews () {
        view.addSubview(usernameEmailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(helpButton)
        view.addSubview(privacyButton)
        view.addSubview(createAccountButton)
        view.addSubview(headerView)
        
    }
    
    @objc private func didTapLoginButton() {
        passwordField.resignFirstResponder()
        usernameEmailField.resignFirstResponder()
        
        guard let email = usernameEmailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        
        AuthManager.shared.signIn(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                    
                    
                case .success:
                    // user logged in
                    
                    self?.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    // error occurred
                    let alert = UIAlertController(title: "Log In Error",
                                                  message: "We were unable to log you in. Please make sure you enter your email/password correctly",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss",
                                                  style: .cancel,
                                                  handler: nil))
                    self?.present(alert, animated: true)
                    print(error)
                }
            }
            
        }
    }
    
    @objc func didTapHelpButton() {
        getInfo()
    }
        
    @objc func didTapTermsButton() {
        guard let url = URL(string: "https://www.termsfeed.com/live/f0ed9aa0-1913-42d1-8071-fa2060e9a09c") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated:true)
    }
    
    @objc func didTapPrivacyButton() {
        guard let url = URL(string: "https://www.termsfeed.com/live/f0ed9aa0-1913-42d1-8071-fa2060e9a09c") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated:true)
    }
    
    @objc func didTapCreateAccountButton() {
        let vc = RegistrationViewController()
        vc.title = "Create Account"
        
        present(UINavigationController(rootViewController: vc), animated:true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

              //Do thing here
        passwordField.resignFirstResponder()
        usernameEmailField.resignFirstResponder()
    }
    
    // MARK: Field Delegate
        
    @nonobjc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameEmailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            didTapLoginButton()
        }
        return true
    }
        
}
