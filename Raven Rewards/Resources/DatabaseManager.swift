//
//  DatabaseManager.swift
//  Raven Rewards
//
//  Created by Alexander Boldt on 8/4/24.
//

import FirebaseDatabase

public class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    @Published
    var userObject: RealUser? = nil
    
    // Mark: -Public
    
    /// Check if username and email is available
    ///  - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    public func canCreateNewUser(with email: String, username: String, completion: (Bool) -> Void) {
        completion(true)
    }
    
    public func getPoints(uid: String) -> Int {
        database.child(uid)
            .observe(.value) { snapshot in
                do{
                    self.userObject = try snapshot.data(as: RealUser.self)
                } catch {
                    print("Can't convert to RealUser type")
                }
                
                
            }
        guard let output = self.userObject?.points else { return 0 }
        return output
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
        guard let oldPoints = self.userObject?.points else { return }
        guard let username = self.userObject?.username else { return }
        database.child(uid).setValue(["username": username, "points": oldPoints + 1])
    }
    
    /// Inserts new user data to database
    ///  - Parameters
    ///     - email: String representing email
    ///     - username: String representing username
    ///     - points: An Int representing this users points
    ///     - completion: Async callback for result if database entry succeded
    public func insertNewUser(with email: String, username: String, points: Int, completion: @escaping (Bool) -> Void) {
        database.child(email.safeDatabaseKey()).setValue(["username": username, "points" : points]) { error, _ in
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
