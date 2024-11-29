//
//  DatabaseManager.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 8/4/24.
//

import FirebaseFirestore
//import Combine

public class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    var userObject: RealUser? = nil
    
    // Mark: -Public
    
    /// Check if username and email is available
    ///  - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    
    
    func getUser(uid: String) async throws -> RealUser {
                do{
                    let snapShot = try await database.child(uid).getData()
                    self.userObject = try snapShot.data(as: RealUser.self)
                } catch {
                    print("Can't convert to RealUser type")
                }
        
        guard let currUser = self.userObject else { return RealUser()}
        return currUser
    }
    
    public func incrPoints(uid: String){
        database.child(uid)
            .observe(.value) { snapshot in
                do{
                    self.userObject = try snapshot.data(as: RealUser.self)
                } catch {
                    print("Can't convert to RealUser type")
                }
                
                
            }
        guard let currUser = self.userObject else { return }
        database.child(uid).setValue(["username": currUser.username, "points" : currUser.points + 1, "bio" : currUser.bio, "profilePhoto" : currUser.profilePhoto, "isAdmin": currUser.isAdmin])
    }
    
    /// Inserts new user data to database
    ///  - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    ///     - points: An Int representing this users points
    ///     - bio: A String representing a user's bio
    ///     - profilePhoto: A String representing the URL of a photo
    ///     - isAdmin: A bool representing Admin perms
    ///     - completion: Async callback for result if database entry succeded
    public func insertNewUser(with email: String, username: String, points: Int, bio: String, profilePhoto: String, isAdmin: Bool, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).setValue(["username": username, "points" : points, "bio" : bio, "profilePhoto" : profilePhoto, "isAdmin": isAdmin]) { error, _ in
            if error == nil {
                // succeded
                completion(true)
                return
            }
            else {
                // failed
                completion(false)
                return
            }
        }
    }
}
