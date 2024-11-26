//
//  AuthManager.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 8/4/24.
//

import FirebaseAuth

public class AuthManager{
    
    static let shared = AuthManager()
    
    // Mark: -Public
    
    public static func getUserName() -> String {
        let user = Auth.auth().currentUser
        guard let name = user?.email else { return "" }
        return name
    }
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        /*
         - Check is username is avaliable
         - Check if email is avaliable
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            if canCreate {
                /*
                 - Create account
                 - Insert account to database
                 */
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else {
                        // Firebase auth could not create account
                        completion(false)
                        return
                    }
                    
                    // Insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        if inserted {
                            completion(true)
                            return
                        }
                        else {
                            // Failed to insert to databaes
                            completion(false)
                            return
                        }
                    }
                }
            }
            else {
                // either username or email does not exist
                completion(false)
            }
        }
    }
    
    public func logicUser(username: String?, email: String?, password: String, completion: @escaping (Bool) -> Void) {
        if let email = email{
            // email log in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            }
        }
        else if let username = username {
            // username log in
            print(username)
        }
    }
    
    /// Attempt to log out firebase user
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            completion(false)
            print(error)
            return
        }
    }
}
