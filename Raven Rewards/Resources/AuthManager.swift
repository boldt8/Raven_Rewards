//
//  AuthManager.swift
//  Instagram
//
//  Created by Afraz Siddiqui on 3/20/21.
//

import FirebaseAuth
import Foundation

/// Object to manage authentication
final class AuthManager {
    /// Shared instanece
    static let shared = AuthManager()

    /// Private constructor
    private init() {}

    /// Auth reference
    public let auth = Auth.auth()
    
    /// Current useremail
    public var currUserID: String {
        guard let username = UserDefaults.standard.string(forKey: "username") else { return "T1" }
        return username
    }
    
    /// Get Current useremail Asynchronously
    public func getCurrUserID(
        completion: @escaping (String) -> Void
    ) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {  return }
        completion(username)
    }
    
    /// Current useremail
    public var currUserEmail: String {
        guard let username = UserDefaults.standard.string(forKey: "email") else { return "" }
        return username
    }

    /// Auth errors that can occur
    enum AuthError: Error {
        case newUserCreation
        case signInFailed
    }

    /// Determine if user is signed in
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }

    /// Attempt sign in
    /// - Parameters:
    ///   - email: Email of user
    ///   - password: Password of user
    ///   - completion: Callback
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<RealUser, Error>) -> Void
    ) {
        DatabaseManager.shared.findUser(with: email) { [weak self] user in
            guard let user = user else {
                completion(.failure(AuthError.signInFailed))
                print("could not find your user")
                return
            }

            self?.auth.signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                    completion(.failure(AuthError.signInFailed))
                    return
            }

                UserDefaults.standard.setValue(user.username, forKey: "username")
                UserDefaults.standard.setValue(user.email, forKey: "email")
                completion(.success(user))
            }
        }
    }

    /// Attempt new user sign up
    /// - Parameters:
    ///   - email: Email
    ///   - username: Username
    ///   - password: Password
    ///   - profilePicture: Optional profile picture data
    ///   - completion: Callback
    public func signUp(
        email: String,
        username: String,
        password: String,
        isAdmin: Bool,
        currentVersion: Double,
        completion: @escaping (Result<RealUser, Error>) -> Void
    ) {
        let newUser = RealUser(username: username, email: email, points: 0, isAdmin: false, currentVersion: currentVersion)
        // Create account
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(.failure(AuthError.newUserCreation))
                return
            }

            DatabaseManager.shared.createUser(newUser: newUser) { success in
                if success {
                    completion(.success(newUser))
                }
                else {
                    completion(.failure(AuthError.newUserCreation))
                }
            }
//            StorageManager.shared.uploadProfilePicture(
//                username: username,
//                data: UIImage(systemName: "Person2")?.pngData()
//            ) { [weak self] success in
//                DispatchQueue.main.async{
//                    if success {
//                        print("hooray")
//                    }
//                }
//            }
        }
    }

    /// Attempt Sign Out
    /// - Parameter completion: Callback upon sign out
    public func signOut(
        completion: @escaping (Bool) -> Void
    ) {
        do {
            try auth.signOut()
            completion(true)
        }
        catch {
            print(error)
            completion(false)
        }
    }
}
