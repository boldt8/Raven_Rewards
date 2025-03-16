//
//  RegistrationViewController.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 8/3/24.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    private var gradeSelection: String = "Click to select grade level"
    
    private let gradeButton = UIButton(primaryAction: nil)
    private func configureGradeSelector() {
        let dataSource = ["Click to select grade level", "9", "10", "11", "12"]
       
        gradeButton.backgroundColor = .secondarySystemBackground
        gradeButton.layer.cornerRadius = Constants.cornerRadius
        
        let actionClosure = { (action: UIAction) in
            self.gradeSelection = action.title
        }

        var menuChildren: [UIMenuElement] = []
        for fruit in dataSource {
            menuChildren.append(UIAction(title: fruit, handler: actionClosure))
        }
        
        gradeButton.menu = UIMenu(options: .displayInline, children: menuChildren)
        
        gradeButton.showsMenuAsPrimaryAction = true
        gradeButton.changesSelectionAsPrimaryAction = true
        
       
    }
    
    private let usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Username..."
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
    
    private let emailField: UITextField = {
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
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let loadingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Loading...", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradeSelector()
        registerButton.addTarget(self,
                                 action: #selector(didTapRegister),
                                 for: .touchUpInside)
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        view.addSubview(loadingButton)
        view.addSubview(gradeButton)
        loadingButton.isHidden = true
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        usernameField.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 100, width: view.width - 40, height: 52)
        emailField.frame = CGRect(x: 20, y: usernameField.bottom + 10, width: view.width - 40, height: 52)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 10, width: view.width - 40, height: 52)
        gradeButton.frame = CGRect(x: 20, y: passwordField.bottom + 10, width: view.width - 40, height: 52)
        registerButton.frame = CGRect(x: 20, y: passwordField.bottom + 72, width: view.width - 40, height: 52)
        loadingButton.frame = CGRect(x: 20, y: passwordField.bottom + 72, width: view.width - 40, height: 52)

    }
    
    private func presentError(type: Int) {
        let alert: UIAlertController
        switch type{
        case 1:
            alert = UIAlertController(title: "Woops", message: "Please make sure to fill all fields and have a password that's atleast 6 characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            break
        case 2:
            alert = UIAlertController(title: "Woops", message: "Don't use spaces or special characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            break
        default:
            alert = UIAlertController(title: "Woops", message: "Please make sure to fill all fields and have a password that's atleast 6 characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        }
      
        present(alert, animated: true)
        loadingButton.isHidden = true
    }
    
    private func presentSelectionError() {
        let alert = UIAlertController(title: "Woops", message: "Please select a grade level", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
        loadingButton.isHidden = true
    }
    
    private func presentInternalError() {
        let alert = UIAlertController(title: "Woops", message: "this email is already taken or we had an internal error.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
        loadingButton.isHidden = true
    }
    
    @objc private func didTapRegister() {
        
        
        let username: String
        let email: String
        let password: String
        
        loadingButton.isHidden = false
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        if (gradeSelection == "Click to select grade level") {
            presentSelectionError()
            return
        }
        guard let preUsername = usernameField.text,
              let preEmail = emailField.text,
              let prePassword = passwordField.text,
              prePassword.count >= 6,
              preUsername.count >= 2
               else {
            presentError(type: 1)
            return
        }
        if(
            !preEmail.trimmingCharacters(in: .whitespaces).isEmpty &&
            !prePassword.trimmingCharacters(in: .whitespaces).isEmpty &&
            !preUsername.trimmingCharacters(in: .whitespaces).isEmpty &&
            preUsername.trimmingCharacters(in: .alphanumerics).isEmpty &&
            prePassword.trimmingCharacters(in: .alphanumerics).isEmpty
        ){
            username = preUsername
            email = preEmail
            password = prePassword
        }
        else {
            presentError(type: 2)
            return
        }
        
        
        DatabaseManager.shared.getCurrentVersion { [weak self] currVer in
            guard let currentVersion = currVer else {
                self?.presentInternalError()
                print("\n\nSign Up Error")
                return 
            }
        
        
            AuthManager.shared.signUp(email: email, username: username, password: password, isAdmin: false, currentVersion: currentVersion, grade:
                                        Int(self?.gradeSelection ?? "1") ?? 1) { [weak self] registered in
                DispatchQueue.main.async{
                    switch registered {
                    case .success(let user):
                        let alert = UIAlertController(title: "Success",
                                                      message: "we successfully created an account",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss",
                                                      style: .cancel,
                                                      handler: {action in  self?.dismiss(animated: true, completion: nil)
                        }))
                        self?.present(alert, animated: true)
                        
                        
                        
                        
                    case .failure(let error):
                        self?.presentInternalError()
                        print("\n\nSign Up Error: \(error)")
                        
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else {
            didTapRegister()
        }
        return true
    }

}
